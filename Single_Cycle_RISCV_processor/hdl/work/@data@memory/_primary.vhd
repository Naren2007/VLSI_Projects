library verilog;
use verilog.vl_types.all;
entity DataMemory is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        WD              : in     vl_logic_vector(31 downto 0);
        WE              : in     vl_logic;
        clk             : in     vl_logic;
        RD              : out    vl_logic_vector(31 downto 0);
        StoreType       : in     vl_logic_vector(1 downto 0);
        LoadType        : in     vl_logic_vector(2 downto 0)
    );
end DataMemory;
