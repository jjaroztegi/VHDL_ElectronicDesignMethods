
# VHDL Electronic Design Methods

This repository contains a collection of VHDL modules developed as part of a university course on **Electronic Design Methods**. Each module demonstrates specific digital design techniques and is structured into directories for source code, simulations, and synthesis files.

## Directory Structure

```plaintext
.
├── divider                     # Signal divider module
├── duration_meter              # Signal duration measurement module
├── parity_detector             # Parity detection module
├── serial-parallel_decoder     # Serial-to-parallel decoder module
└── waveform_generator          # Waveform generation module
```

Each module includes:
- **`src/`**: VHDL source files and testbenches.  
- **`sim/`**: Simulation files for verification.  
- **`syn/`**: Synthesis scripts and results.

## Modules Overview

### Divider
- **Purpose:** Divides input signals (e.g., frequency division).  
- **Key Features:** Configurable counter for flexible division ratios.

### Duration Meter
- **Purpose:** Measures the duration of input signals.  
- **Key Features:** Accurate timing and configurable resolution.

### Parity Detector
- **Purpose:** Detects the parity (even or odd) of binary data streams.  
- **Key Features:** Real-time parity detection.

### Serial-Parallel Decoder
- **Purpose:** Converts serial input data into parallel output.  
- **Key Features:** Supports configurable data widths.

### Waveform Generator
- **Purpose:** Generates customizable digital waveforms for testing.  
- **Key Features:** Flexible pattern generation.

## Tools Used

The following Synopsys tools were used for simulation, analysis, and synthesis:
- **[VCS](https://www.synopsys.com/verification/simulation/vcs.html):** For simulation and functional verification of VHDL designs.  
- **[Verdi](https://www.synopsys.com/verification/debug/verdi.html):** For advanced debugging and waveform analysis.  
- **[Design Vision](https://www.synopsys.com/implementation-and-signoff/rtl-synthesis-test/dc-ultra.html):** For logic synthesis and design optimization.

## How to Use

1. **Clone the Repository**  
   ```bash
   git clone https://github.com/yourusername/vhdl-electronic-design-methods.git
   ```

2. **Navigate to a Module**  
   Example: For the `divider` module:  
   ```bash
   cd divider/sim
   ```

3. **Run Simulations**  
   Use Synopsys VCS to verify functionality:  
   ```bash
   source analisis.scr
   vcs -kdb tb_div_cfg
   ```

4. **Analyze Results**  
   Use Verdi to view waveforms and debug:  
   ```bash
   ./simv .gui = verdi &
   ```

5. **Synthesize the Design**  
   Use Design Vision for synthesis and timing analysis.
   ```bash
   cd ../syn
   design_vision &
   ```

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for more details.
