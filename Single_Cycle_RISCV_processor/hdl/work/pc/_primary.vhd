library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        PCNext          : in     vl_logic_vector(31 downto 0);
        PC              : out    vl_logic_vector(31 downto 0)
    );
end pc;
