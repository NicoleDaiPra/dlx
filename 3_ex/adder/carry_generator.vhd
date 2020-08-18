library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fun_pack_adder.all;
use ieee.math_real.log2;

entity carry_generator is
    generic (
        N: integer := 32
    );
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		cout: out std_logic_vector(N/4-1 downto 0)
	);
end entity carry_generator;

architecture struct of carry_generator is
	component pg_network is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			g: out std_logic_vector(N-1 downto 0);
			p: out std_logic_vector(N-1 downto 0)
		);
	end component pg_network;

	component pg_unit is
		port (
			a: in std_logic; -- Gi:k
			b: in std_logic; -- Pi:k
			c: in std_logic; -- Gk-1:j
			d: in std_logic; -- Pk-1:j
			p: out std_logic; -- Pi:j 
			g: out std_logic -- Gi:j
		);
	end component pg_unit;

	component g_unit is
		port (
			a: in std_logic; -- Gi:k
			b: in std_logic; -- Pi:k
			c: in std_logic; -- Gk-1:j
			g: out std_logic -- Gi:j
		);
	end component g_unit;

    constant LEVEL: integer := integer(log2(real(N)));
    
	type pg_type is array (0 to N) of std_logic_vector(1 downto 0); -- pos 1 -> p, pos 0 -> g
    type carry_matrix is array (0 to LEVEL) of pg_type;

	signal p_net: std_logic_vector(N-1 downto 0); -- propagate result of pg_network
	signal g_net: std_logic_vector(N-1 downto 0); -- generate result of pg_network
    signal matrix: carry_matrix;
	signal carry: std_logic_vector(N/4-1 downto 0);

begin
	pgn: pg_network -- instantiate pg_network
		generic map (
			N => N
		)
		port map (
			a => a,
			b => b,
			cin => cin,
			g => g_net,
			p => p_net
		);
    
    -- the first two levels are always guaranteed to exist, 
    -- because the carry_generator	has to work on at least 4 bit
    g_0: g_unit
        port map (
            a => g_net(1),
            b => p_net(1),
            c => g_net(0),
            g => matrix(0)(1)(0)
        );
        
    g_1: g_unit
        port map (
            a => matrix(0)(3)(0),
            b => matrix(0)(3)(1),
            c => matrix(0)(1)(0),
            g => matrix(1)(3)(0)
        );
        
        carry(0) <= matrix(1)(3)(0);
        
    gen_pg_0: for i in 1 to N/2-1 generate
        pg_i: pg_unit
            port map (
                a => g_net(2*i+1),
                b => p_net(2*i+1),
                c => g_net(2*i),
                d => p_net(2*i),
                g => matrix(0)(2*i+1)(0),
                p => matrix(0)(2*i+1)(1)
            );
    end generate gen_pg_0;
    
    gen_pg_1: for i in 1 to N/4-1 generate
        pg_i: pg_unit
            port map (
                a => matrix(0)(4*i+3)(0),
                b => matrix(0)(4*i+3)(1),
                c => matrix(0)(4*i+1)(0),
                d => matrix(0)(4*i+1)(1),
                g => matrix(1)(4*i+3)(0),
                p => matrix(1)(4*i+3)(1)
            );
    end generate gen_pg_1;
    
    -- this generate is executed only if N > 4
    gen_lvl: for lvl in 2 to LEVEL-1 generate
        -- for each level iterate over all the possible positions
        gen_i: for i in 0 to N-1 generate
            -- skip the case for i = 0 as it is never used to generate anything
            gen_if: if (i > 0) generate
                -- i = 4*(2**(lvl-2)+1)-1 is the first position where a g_unit must be instantiated at the current level
                gen_gu: if (i = 4*(2**(lvl-2)+1)-1) generate
                    -- instantiate the number of g_units required by the current level
                    gen_j: for j in 0 to 2**(lvl-2)-1 generate
                        gu: g_unit
                            port map (
                                a => matrix(level_index(j))(i+4*j)(0),
                                b => matrix(level_index(j))(i+4*j)(1),
                                c => matrix(lvl-1)(last_g_unit_prev_lvl(lvl))(0),
                                g => matrix(lvl)(i+4*j)(0)
                            );
                            
                            -- the output of a g_unit is also a cout
                            carry((i+4*j)/4) <= matrix(lvl)(i+4*j)(0);
                    end generate gen_j;
                end generate gen_gu;
                
                -- if pg_i_start_block returns 1 the current i is a position where the first pg_unit of a block must be instantiated
                gen_pgu: if (pg_i_start_block(i, lvl, N) = 1) generate
                    -- instantiate the number of pg_units required by the current level in this block
                    gen_j: for j in 0 to 2**(lvl-2)-1 generate
                        pgu: pg_unit
                            port map (
                                a => matrix(level_index(j))(i+4*j)(0),
                                b => matrix(level_index(j))(i+4*j)(1),
                                c => matrix(lvl-1)(i-4)(0),
                                d => matrix(lvl-1)(i-4)(1),
                                g => matrix(lvl)(i+4*j)(0),
                                p => matrix(lvl)(i+4*j)(1)
                            );
                    end generate gen_j;
                end generate gen_pgu;
            end generate gen_if;
        end generate gen_i;
    end generate gen_lvl;
    
    cout <= carry; -- assign the output
end architecture struct;