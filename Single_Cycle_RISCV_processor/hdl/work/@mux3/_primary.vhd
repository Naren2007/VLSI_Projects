library verilog;
use verilog.vl_types.all;
entity Mux3 is
    port(
        D0              : in     vl_logic_vector(31 downto 0);
        D1              : in     vl_logic_vector(31 downto 0);
        D2              : in     vl_logic_vector(31 downto 0);
        S               : in     vl_logic_vector(1 downto 0);
        Y               : out    vl_logic_vector(31 downto 0)
    );
end Mux3;
