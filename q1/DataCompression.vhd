library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataCompression is

    port(clk, rst : in std_logic;
		input : in std_logic_vector(7 downto 0);      
		valid: out std_logic;
       output: out std_logic_vector(7 downto 0) );    
end entity;


architecture datacompression of DataCompression is

	signal prev_char: std_logic_vector(7 downto 0);


begin

process (clk,rst) 
	variable buffer_v : std_logic_vector(1536 downto 0);
	variable l ,r,count: integer;	


	begin
		if rising_edge(clk) then
			if rst = '1' then
				count := 0;
				prev_char <= "00000000";
				l := 0;
				r := 0;
				valid <= '0';
			else
				if prev_char = "00000000" then
					count := 1;
					prev_char<=input;
				
				elsif prev_char = input then
					count := count + 1;
					
					if prev_char /= "00011011" and count = 5 then
						--output esc n input
						buffer_v (r + 7 downto r) := "00011011";
						buffer_v (r + 15 downto r + 8) := "00000101";
						buffer_v (r + 23 downto r + 16) := prev_char (7 downto 0);
						r := r + 24;
						count := 0;
					end if;
					
					if prev_char = "00011011" and count = 6 then
						--output esc n esc
						buffer_v (r + 7 downto r)  := "00011011";
						buffer_v (r + 15 downto r + 8) := "00000110";
						buffer_v (r + 23 downto r + 16) := "00011011";
						r := r + 24;
						count := 0;
					end if;
					
					--prev_char <= input;
					
				else
				
-----------------------------------------------------------------------------------------------				
--					if prev_char /= "00011011" then
--						if count = 1 then
--							count <= 1;
--							--output prev_char
--							buffer_v (r + 7 downto r) <= prev_char(7 downto 0);
--							r <= r + 8;
--						elsif count = 2 then
--							count <= 1;
--							--output prev_char prev_char
--							buffer_v (r + 7 downto r) <= prev_char(7 downto 0);
--							buffer_v (r + 15 downto r + 8) <= prev_char(7 downto 0);
--							r <= r + 16;
--						else
--							count <= 1;
--							--output esc n prev_char
--							buffer_v (r + 7 downto r)  <= "00011011";
--							buffer_v (r + 15 downto r + 8) <= std_logic_vector(to_unsigned(count, 8));
--							buffer_v (r + 23 downto r + 16) <= prev_char(7 downto 0);
--						end if;
--							
--					else
--						count <= 1;
--						--output esc n esc
--						buffer_v (r + 7 downto r)  <= "00011011";
--						buffer_v (r + 15 downto r + 8) <= std_logic_vector(to_unsigned(count, 8));
--						buffer_v (r + 23 downto r + 16) <= "00011011";
--					end if;
----------------------------------------------------------------------------------------------------------------------

					if prev_char = "00011011" then
						if count /= 0 then 
							buffer_v (r + 7 downto r)  := "00011011";
							buffer_v (r + 15 downto r + 8) := std_logic_vector(to_unsigned(count, 8));
							buffer_v (r + 23 downto r + 16) := "00011011";
							r := r + 24;
						end if;
					elsif count = 1 then
						buffer_v (r + 7 downto r) := prev_char(7 downto 0);
						r := r + 8;
					elsif count = 2 then
						buffer_v (r + 7 downto r) := prev_char(7 downto 0);
						buffer_v (r + 15 downto r + 8) := prev_char(7 downto 0);
						r := r + 16;
					elsif count >2 and count < 6 then
						buffer_v (r + 7 downto r)  := "00011011";
						buffer_v (r + 15 downto r + 8) := std_logic_vector(to_unsigned(count, 8));
						buffer_v (r + 23 downto r + 16) := prev_char(7 downto 0);
						r := r + 24;
					else
					end if;
					count := 1;
					prev_char <= input;
				end if;
				if l + 5 < r then
					output <= buffer_v(l+7 downto l);
					l := l + 8;
					valid <= '1';
			else
				valid <= '0';
				output <= "UUUUUUUU";
			end if;
				
			end if;
				

		
		end if;
	end process;
	
end architecture;
