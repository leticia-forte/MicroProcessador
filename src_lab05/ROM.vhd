library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port 
    (
        clk     : in std_logic;
        endereco : in unsigned (17 downto 0);
        data    : out unsigned (17 downto 0)
    );
end entity ROM;

architecture a_ROM of ROM is
    type memory is array (0 to 65535) of unsigned (17 downto 0);
    constant rom_data : memory := (
        0  => B"0110_011_000_000_101_00", -- LD r3, 5
        1  => B"0110_100_000_001_000_00", -- LD r4, 8
        2  => B"0111_000_011_000_000_01", -- MOV A, r3
        3  => B"0100_000_100_000_000_01", -- ADD A, r4
        4  => B"0111_101_000_000_000_01", -- MOV r5, A
        5  => B"0101_000_000_000_001_01", -- SUBI A, 1 
        6  => B"0111_101_000_000_000_01", -- MOV r5, A
        7  => B"1111_111_000_010_100_00", -- JUMP 20
        8  => B"0110_101_000_000_000_00", -- LD r5, 0
        20 => B"0111_000_011_000_000_01", -- MOV A, r3
        21 => B"0111_101_000_000_000_01", -- MOV r5, A
        22 => B"1111_111_000_000_010_00", -- JUMP 02
        23 => B"0110_011_000_000_000_00", -- LD r3, 0
        others => (others=>'0')
        --NOP 0000_xxx_xxx_xxx_xxx_xx
    );


--  A. Carrega R3 (o registrador 3) com o valor 5
--  B. Carrega R4 com 8
--  C. Soma R3 com R4 e guarda em R5
--  D. Subtrai 1 de R5
--  E. Salta para o endereço 20
--  F. Zera R5 (nunca será executada)
--  G. No endereço 20, copia R5 para R3
--  H. Salta para o passo C desta lista (R5 <= R3+R4)
--  I. Zera R3 (nunca será executada)



begin
    process(clk)
    begin
        if rising_edge(clk) then
            data <= rom_data(to_integer(endereco));
        end if;
    end process;
end architecture a_ROM;