library verilog;
use verilog.vl_types.all;
entity Extend is
    port(
        Instr           : in     vl_logic_vector(31 downto 0);
        ImmSrc          : in     vl_logic_vector(2 downto 0);
        ImmExt          : out    vl_logic_vector(31 downto 0)
    );
end Extend;
