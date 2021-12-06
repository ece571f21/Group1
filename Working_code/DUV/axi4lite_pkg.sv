//==========================================================================
// axi4lite_pkg.sv -Package for AXI4 Lite protocol
// Description:
// Contains package that includes parameters/enum used in master and slave
//==========================================================================

package axi4lite_pkg;

  parameter
      ADDRWIDTH = 32,// Address width of the bus
      DATAWIDTH = 32;// Data width of the bus

typedef enum logic [1:0] {IDLE, ADDR, DATA, RESP} state; // states for read/write operation

endpackage: axi4lite_pkg
