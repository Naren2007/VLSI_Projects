library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        opcode          : in     vl_logic_vector(6 downto 0);
        funct3          : in     vl_logic_vector(2 downto 0);
        funct7          : in     vl_logic_vector(6 downto 0);
        RegWrite        : out    vl_logic;
        ALUSrc          : out    vl_logic;
        MemWrite        : out    vl_logic;
        ResultSrc       : out    vl_logic_vector(1 downto 0);
        ImmSrc          : out    vl_logic_vector(2 downto 0);
        ALUControl      : out    vl_logic_vector(3 downto 0);
        Branch          : out    vl_logic;
        BranchType      : out    vl_logic_vector(2 downto 0);
        Jump            : out    vl_logic;
        Jalr            : out    vl_logic;
        StoreType       : out    vl_logic_vector(1 downto 0);
        LoadType        : out    vl_logic_vector(2 downto 0)
    );
end ControlUnit;
