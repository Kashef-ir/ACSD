# Automatic Control System Designer (ACSD)

A comprehensive MATLAB-based tool for designing, analyzing, and simulating automatic control systems with multiple transfer function blocks.

## Features

- **Flexible System Configuration**: Support for multiple transfer function blocks with custom numerator and denominator coefficients
- **Multiple Connection Types**: Series, parallel, and feedback configurations with support for nested combinations
- **Input Signal Types**: Step, ramp, and sinusoidal input signals
- **Comprehensive Analysis**:
  - Time-domain response plots
  - Performance metrics (rise time, settling time, overshoot, etc.)
  - Steady-state error calculations
  - Frequency domain analysis (Bode, Nyquist plots)
  - Pole-zero maps and root locus
- **Automatic Simulink Model Generation**: Creates ready-to-use Simulink models from your system configuration
- **Stability Analysis**: Automatic stability checking based on pole locations

## Requirements

- MATLAB R2018b or later
- Control System Toolbox
- Simulink (optional, for model generation)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/Kashef-ir/ACSD.git
```

2. Navigate to the project directory:
```bash
cd ACSD
```

3. Open MATLAB and add the directory to your path, or run the script directly

## Usage

### Basic Workflow

1. Run the script in MATLAB:
```matlab
ACSD
```

2. Enter the number of transfer function blocks when prompted

3. Define each transfer function by providing numerator and denominator coefficients:
   - Example: For `(s+2)/(s²+3s+1)`, enter:
     - Numerator: `[1 2]`
     - Denominator: `[1 3 1]`

4. Specify the connection structure using MATLAB's control system functions:
   - `series(G1,G2)` - Series connection
   - `parallel(G1,G2)` - Parallel connection
   - `feedback(G1,G2)` - Feedback loop
   - Nested combinations: `feedback(series(G1,G2),G3)`

5. Select the input signal type:
   - Step input
   - Ramp input
   - Sinusoidal input (specify frequency)

6. Optionally generate a Simulink model of your system

### Example

```matlab
Enter the number of blocks: 2

Block G1:
 Numerator of G1 = [1]
 Denominator of G1 = [1 2]

Block G2:
 Numerator of G2 = [3]
 Denominator of G2 = [1 4 3]

Connection string: feedback(series(G1,G2),1)

Select the system input type:
 1 - Step
Your choice: 1
```

## Output

The program provides:

### Graphical Outputs
- Input signal plot
- System output response
- Input vs output comparison
- Pole-zero map
- Bode diagram
- Nyquist plot
- Root locus

### Numerical Metrics
For **step input**:
- Rise time
- Settling time
- Overshoot and undershoot
- Peak value and time
- Steady-state value and error

For **ramp input**:
- Velocity error constant (Kv)
- Steady-state error
- Tracking error

For **sinusoidal input**:
- Amplitude ratio (gain)
- Gain in dB
- Phase shift

### System Information
- Poles and zeros
- Stability analysis
- Transfer function representation

## Simulink Model Generation

When enabled, the program automatically:
- Creates a new Simulink model
- Adds all transfer function blocks
- Configures connections based on your specified structure
- Adds input source and output scope
- Arranges blocks for optimal visualization

## Supported Connection Patterns

- Simple series: `series(G1,G2)`
- Simple parallel: `parallel(G1,G2)`
- Simple feedback: `feedback(G1,G2)`
- Complex nested structures (manual connection may be required)

## Limitations

- Complex nested structures may require manual Simulink connections
- Simulink model generation works best with simple configurations
- Some performance metrics may not be calculable for unstable or improper systems

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

### Planned Improvements
- Enhanced support for complex nested connection structures
- PID controller design integration
- Frequency response analysis tools
- Export functionality for plots and data

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Kashef-ir - [@Kashef-ir](https://github.com/Kashef-ir)

## Acknowledgments

- Built using MATLAB Control System Toolbox
- Inspired by classical control system theory and design principles

---

**Note**: This tool is designed for educational and research purposes in control systems engineering.