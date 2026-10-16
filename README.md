# Learning Fuel Cells Through Data: An IoT and Machine Learning Lab

[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/184946-learning-fuel-cells-through-data) or [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UTT-HCC-Research/Learning-PEMFC-IoT-ML&project=Learning_PEMFC_IoT_ML.prj)

**Curriculum Module**

_Created with R2026b. Compatible with R2026b and later releases._

This curriculum module uses a proton exchange membrane fuel cell
(PEMFC) test bench to introduce experimental data collection, local data
logging, cloud-based monitoring with ThingSpeak, and data-driven analysis
workflows in MATLAB.

The module is intended for demonstrations, guided laboratory sessions, or
interactive assignments in energy systems, instrumentation, controls,
computer engineering, mechanical engineering, chemical engineering, and
electrical engineering courses.

## Getting Started
### Accessing the Module
### **On MATLAB Online:**

Use the [![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=UTT-HCC-Research/Learning-PEMFC-IoT-ML&project=Learning_PEMFC_IoT_ML.prj) link to download the module. You will be prompted to log in or create a MathWorks account. The project will be loaded, and you will see an app with several navigation options to get you started.

### **On Desktop:**

Download or clone this repository. Open MATLAB, navigate to the folder containing these scripts and double\-click on Learning_PEMFC_IoT_ML.prj

Run each live script one section at a time. For hardware-connected
sections, update device names, COM ports, channel IDs, and API keys before
running the code.

## Module Contents

- `MainMenu.m`: Entry point for the module. The MATLAB Project startup file opens this menu automatically.
- `Scripts/PEMFC_Testing.mlx`: Live script for PEMFC hardware setup, instrument connection, measurement, data logging, and plotting.
- `Scripts/Connect2PEMFC.mlx`: Live script for reading PEMFC data, uploading measurements to ThingSpeak, viewing a cloud dashboard, and downloading data.
- `Data/`: Example PEMFC datasets in CSV, Excel, and MAT formats.


## Required MathWorks Products

The current scripts require:

- [MATLAB](https://www.mathworks.com/products/matlab.html) for live
  scripts, tables, plotting, spreadsheet/CSV import, serial
  communication, and ThingSpeak read/write functions.
- [Data Acquisition Toolbox](https://www.mathworks.com/products/data-acquisition.html)
  for the NI DAQ workflow used in `PEMFC_Testing.mlx`, including
  `daq("ni")` and `addinput`.
- [Data Acquisition Toolbox Support Package for National Instruments NI-DAQmx Devices](https://www.mathworks.com/hardware-support/nidaqmx.html)
  when using National Instruments hardware.
- A [ThingSpeak](https://thingspeak.com/) account and channel for cloud
  upload, dashboard visualization, and data download activities.

Optional, depending on how the module is taught:

- [MATLAB Copilot](https://www.mathworks.com/products/matlab-copilot.html)
  for the prompt-improvement and debugging activities.
- [Simulink](https://www.mathworks.com/products/simulink.html) and
  [Simscape](https://www.mathworks.com/products/simscape.html) as
  background tools for model-based and physical-system extensions.
- [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html)
  for future or instructor-added machine learning activities beyond the
  included data collection and ThingSpeak scripts.


## Learning Objectives

After completing the included activities, students should be able to:

- Describe the role of PEM fuel cells in low-carbon energy systems.
- Connect MATLAB to laboratory instruments.
- Acquire PEMFC voltage, current, temperature, pressure, and flow data.
- Save experimental measurements to local data files.
- Calculate and plot electrical power from measured voltage and current.
- Upload selected PEMFC measurements to ThingSpeak.
- Read data back from ThingSpeak and save it for later analysis.
- Use AI assistance critically when improving, debugging, and validating
  MATLAB code.

## Reference Resources

Recommended MathWorks learning resources:

- [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted)
- [Simulink Onramp](https://matlabacademy.mathworks.com/details/simulink-onramp/simulink)
- [Simscape Onramp](https://matlabacademy.mathworks.com/details/simscape-onramp/simscape)
- [Machine Learning Onramp](https://matlabacademy.mathworks.com/details/machine-learning-onramp/machinelearning)

Relevant documentation:

- [MATLAB Live Editor](https://www.mathworks.com/help/matlab/live-editor.html)
- [Tables](https://www.mathworks.com/help/matlab/tables.html)
- [Data Acquisition Toolbox Documentation](https://www.mathworks.com/help/daq/)
- [ThingSpeak Documentation](https://www.mathworks.com/help/thingspeak/)

Additional educator resources:

- [MathWorks Teaching Resources](https://www.mathworks.com/academia/courseware.html)
- [MathWorks Educator Resources](https://www.mathworks.com/academia/educators.html)
