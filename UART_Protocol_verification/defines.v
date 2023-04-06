//////////////////////////////////////////////////////////////////////////
// DUV FIFO CONFIGURATIONS
// DUV FIFO Depth and width
 `define DATA_WIDTH 8
 `define DEPTH 32
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// TEST BENCH ARCHITECTURE CONFIGURATIONS
// LAB:Define the enumerated types for input data size
//     `define SMALL,MEDIUM,LARGE as 1,2,3 respectively
 `define SMALL 1
 `define MEDIUM 2
 `define LARGE 3

// LAB:Define the number of writes & reads to the fifo
 `define no_of_writes 32
 `define no_of_reads 32

// LAB:Define the Seed number for different Random values
 `define SEED 5

// 0--False 1--true
// Random values for enables can take values 0 or 1
// If Directed is ON then Random must be OFF

// LAB:`define RANDOM
 `define RANDOM 0

// Directed values for enables can take values 0 or 1
// any one should be true at a given time
// If Random is ON then Directed must be OFF

// LAB: 4 cases possible `define each of them
 `define wr_rd_00 1
 `define wr_rd_01 0
 `define wr_rd_10 0
 `define wr_rd_11 0

// Debugging enable can take values 0 or 1 used for displays ON & OFF
// LAB: `define DEBUG
 `define DEBUG 0

//////////////////////////////////////////////////////////////////////////
