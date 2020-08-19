library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity boothmul is
    generic (
        N: integer := 32
    );
    port (
        a: in std_logic_vector(N-1 downto 0);
        b: in std_logic_vector(N-1 downto 0);
        y: out std_logic_vector(2*N-1 downto 0)
    );
end boothmul;

architecture struct of boothmul is
    component mux_5x1 is
        generic (
            NBIT: integer := 4
        );
        port (
            a: in	std_logic_vector(NBIT downto 0);
            b: in	std_logic_vector(NBIT downto 0);
            c: in	std_logic_vector(NBIT downto 0);
            d: in	std_logic_vector(NBIT downto 0);
            e: in	std_logic_vector(NBIT downto 0);
            sel: in std_logic_vector(2 downto 0);
            y: out std_logic_vector(NBIT downto 0)
        );
    end component mux_5x1;
    
    component rca_generic is
        generic (
            N: integer := 8
        );
        port (
            a: in std_logic_vector(N-1 downto 0);
            b: in std_logic_vector(N-1 downto 0);
            cin: in std_logic;
            s: out std_logic_vector(N-1 downto 0);
            cout: out std_logic
        );
    end component rca_generic;
    
    component booth_encoder is
        generic (
            NBIT: integer := 32;
            NMUX: integer := 16
        );
        port (
            b: in std_logic_vector(NBIT-1 downto 0);
            y: out std_logic_vector(3*NMUX-1 downto 0)    
        );
    end component booth_encoder;
    
    component mux_in_generator is
        generic (
            NBIT: integer := 32;
            SHIFT_LEVEL: integer := 3
        );
        port (
            a: in std_logic_vector(NBIT-1 downto 0);
            zeros: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
            pos_a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
            neg_a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
            pos_2a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0);
            neg_2a: out std_logic_vector(NBIT+(SHIFT_LEVEL*2) downto 0)
        );
    end component mux_in_generator;
    
    component sign_extender is
        generic (
        NBIT: integer := 4
    );
    port (
        msb: in std_logic;
        ext: out std_logic_vector(NBIT-1 downto 0)
    );
    end component sign_extender;
    
    -- calculate the right number of muxes needed, both for even and odd number of bits cases
    constant NMUX: integer := to_integer(unsigned(std_logic_vector(to_unsigned(N/2+1, (N/2))) and (not std_logic_vector(to_unsigned(1, n/2)))));
    
    -- all the components are instantiated to be of the minimum size requested for their stage so that
    -- they're minimum in size (we spare hardware and time during the synthesis).

    -- although mux_net_type is an array of all vectors 2*N-2 bits long, the synthetizer will eliminate all the unused wires,
    -- therefore they do not waste hardware.
    type nmux_in_net_type is array (0 to 5*NMUX-1) of std_logic_vector(2*N-1 downto 0);
    type nmux_out_net_type is array (0 to NMUX-1) of std_logic_vector(2*N-1 downto 0);
    type rca_net_type is array (0 to NMUX-2) of std_logic_vector(2*N-1 downto 0);
    
    signal mux_in_nets: nmux_in_net_type;
    signal mux_out_nets: nmux_out_net_type;
    signal mux_sel_nets: std_logic_vector(3*NMUX-1 downto 0);
    signal rca_out: rca_net_type;
    signal carries: std_logic_vector(NMUX-2 downto 0); -- it stores also the carry out
    
begin
    encoder: booth_encoder
            generic map (
                NBIT => N,
                NMUX => NMUX
            )
            port map (
                b => b,
                y => mux_sel_nets
            );
            
    mux_gen: for i in 0 to NMUX-1 generate
        first_mux: if (i = 0) generate -- the first mux has to be extended to N+2 bit to perform the addition
            mux_in: mux_in_generator
                generic map (
                    NBIT => N,
                    SHIFT_LEVEL => i
                )
                port map (
                    a => a,
                    zeros => mux_in_nets(5*i+0)((N)+(i*2) downto 0),
                    pos_a => mux_in_nets(5*i+1)((N)+(i*2) downto 0),
                    neg_a => mux_in_nets(5*i+2)((N)+(i*2) downto 0),
                    pos_2a => mux_in_nets(5*i+3)((N)+(i*2) downto 0),
                    neg_2a => mux_in_nets(5*i+4)((N)+(i*2) downto 0)
                );
                
            mux: mux_5x1
                generic map (
                    NBIT => (N)+(i*2)
                )
                port map (
                    a => mux_in_nets(5*i+0)((N)+(i*2) downto 0),
                    b => mux_in_nets(5*i+1)((N)+(i*2) downto 0),
                    c => mux_in_nets(5*i+2)((N)+(i*2) downto 0),
                    d => mux_in_nets(5*i+3)((N)+(i*2) downto 0),
                    e => mux_in_nets(5*i+4)((N)+(i*2) downto 0),
                    sel => mux_sel_nets(3*i+2 downto 3*i),
                    y => mux_out_nets(i)((N)+(i*2) downto 0)
                );
            
            -- sign extension for the first mux, because it outputs N+1 bits while for the addition N+3 are needed
            mux_ext: sign_extender
                generic map (
                    NBIT => 2
                )
                port map (
                    msb => mux_out_nets(i)(N+(i*2)),
                    ext => mux_out_nets(i)(N+2+(i*2) downto N+1+(i*2))
                );
        end generate first_mux;    
        
        mux_i: if (i > 0) generate
            mux_in: mux_in_generator
                generic map (
                    NBIT => N,
                    SHIFT_LEVEL => i
                )
                port map (
                    a => a,
                    zeros => mux_in_nets(5*i+0)(N+(i*2) downto 0),
                    pos_a => mux_in_nets(5*i+1)(N+(i*2) downto 0),
                    neg_a => mux_in_nets(5*i+2)(N+(i*2) downto 0),
                    pos_2a => mux_in_nets(5*i+3)(N+(i*2) downto 0),
                    neg_2a => mux_in_nets(5*i+4)(N+(i*2) downto 0)
                );
                
            mux: mux_5x1
                generic map (
                    NBIT => N+(i*2)
                )
                port map (
                    a => mux_in_nets(5*i+0)(N+(i*2) downto 0),
                    b => mux_in_nets(5*i+1)(N+(i*2) downto 0),
                    c => mux_in_nets(5*i+2)(N+(i*2) downto 0),
                    d => mux_in_nets(5*i+3)(N+(i*2) downto 0),
                    e => mux_in_nets(5*i+4)(N+(i*2) downto 0),
                    sel => mux_sel_nets(3*i+2 downto 3*i),
                    y => mux_out_nets(i)(N+(i*2) downto 0)
                );
        end generate mux_i;    
    end generate mux_gen;
    
    rca_gen: for i in 0 to NMUX-2 generate
        first_rca: if (i = 0) generate
            rca_0: rca_generic
                generic map (
                    N => N+3
                )
                port map (
                    a => mux_out_nets(i)(N+2 downto 0),
                    b => mux_out_nets(i+1)(N+2 downto 0),
                    cin => '0',
                    s => rca_out(i)(N+2 downto 0),
                    cout => carries(i)
                );
            rca_ext_0: sign_extender
                generic map (
                    NBIT => 2
                )
                port map (
                    msb => carries(i),
                    ext => rca_out(i)(N+4+(i*2) downto N+3+(i*2))
                );     
        end generate first_rca;
        
        rca: if (i > 0 and i < NMUX-2) generate
            rca_i: rca_generic
                generic map (
                    N => (N+1)+((i+1)*2)
                )
                port map (
                    a => mux_out_nets(i+1)(N+((i+1)*2) downto 0),
                    b => rca_out(i-1)(N+((i+1)*2) downto 0),
                    cin => '0',
                    s => rca_out(i)(N+((i+1)*2) downto 0),
                    cout => carries(i)
                );
                
                rca_ext_i: sign_extender
                generic map (
                    NBIT => 2
                )
                port map (
                    msb => carries(i),
                    ext => rca_out(i)(N+4+(i*2) downto N+3+(i*2))
                );
        end generate rca;
        
        last_rca: if (i = NMUX-2) generate
            last_rca: rca_generic
                generic map (
                    N => (N+1)+((i+1)*2)
                )
                port map (
                    a => mux_out_nets(i+1)(N+((i+1)*2) downto 0),
                    b => rca_out(i-1)(N+((i+1)*2) downto 0),
                    cin => '0',
                    s => rca_out(i)(N+((i+1)*2) downto 0),
                    cout => carries(i)
                );
        end generate last_rca;
    end generate;
    
    -- rca_out(NMUX-2) is made by 2*N-2 bit.
    -- To obtain the final result, the carry out of the last addition must be concatenated to it
    y <= carries(NMUX-2)&rca_out(NMUX-2)(2*N-2 downto 0);
end struct;
