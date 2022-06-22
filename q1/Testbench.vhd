library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity Testbench is
end entity;

architecture datacompression_vd of Testbench is
	component DataCompression
		port( clk, rst: in std_logic;
		input: in std_logic_vector(7 downto 0);
		valid: out std_logic;
		output: out std_logic_vector(7 downto 0));
	end component;
	signal clk, rst, valid: std_logic;
	signal input, output: std_logic_vector(7 downto 0);
	--signal output_vector : std_logic_vector(7 downto 0);
	begin
		inst: DataCompression port map(clk, rst, input, valid, output);
		process
			variable LINE_COUNT: integer := 0;
			variable INPUT_LINE: line;
			variable OUTPUT_LINE: line;
			variable input_char: std_logic_vector(7 downto 0);
			file INFILE: text;
			file OUTFILE: text;
-------------------------------------------		
	function to_bit_vector(x: std_logic_vector) return bit_vector is
		variable ret_val: bit_vector((x'length -1 ) downto 0);
	begin 
		for I in (x'length-1) downto 0 loop
				if(x(I) = '1') then
					ret_val(I):='1';
				else 
					ret_val(I) := '0';
				end if;
			end loop;
		return ret_val;
	
	end to_bit_vector;	
-------------------------------------	
		begin
			rst <= '1';
			input <= (others => '0');
			clk <= '0';
			wait for 1ns;
			rst <= '1';
			input <= (others => '0');
			clk <= '1';
			wait for 1ns;
			rst <= '0';
			input <= (others => '0');
			clk <= '0';
			wait for 1ns;
			file_open(INFILE, "/home/chetan/Desktop/Semester4/CS232DLDCALab/lab6/q1/input.txt",  read_mode);
			
			while LINE_COUNT<129 loop
				if LINE_COUNT = 0 THEN
					file_open(OUTFILE, "/home/chetan/Desktop/Semester4/CS232DLDCALab/lab6/q1/output.txt", write_mode);
				END IF;
				LINE_COUNT := LINE_COUNT + 1;
				if LINE_COUNT < 64 then
					readline(INFILE, INPUT_LINE);
					read(INPUT_LINE, input_char);
					input <= input_char;
				elsif LINE_COUNT = 64 then 
					file_close(INFILE);
					input <= (others => '0');	
				else
					input <= (others => '0');
				end if;
				if valid = '1' then
					--output_vector <= output;
					--report output_vector;
					write(OUTPUT_LINE, output);
					writeline(OUTFILE, OUTPUT_LINE);
				end if;
				clk <= '1';
				wait for 1ns;
				clk <= '0';
				wait for 1ns;
				report "line_count = " & integer'image(LINE_COUNT);
			end loop;
			file_close(OUTFILE);
		end process;
				
end architecture;
