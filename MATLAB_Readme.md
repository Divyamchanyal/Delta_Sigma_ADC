**Delta-Sigma (**∆Σ**) Modulator**

Simulation Framework – MATLAB & Simulink![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.001.png)

**Project Overview**

This repository contains MATLAB scripts and Simulink models used to simulate **ideal**, **non-ideal**, and **noise-injected** Delta-Sigma (∆Σ) ADC architectures.

It includes a comprehensive workflow for:

- Digital decimation filter design.
- Advanced noise modeling (Flicker, Thermal, Jitter).
- ENOB (Effective Number of Bits) vs. Sampling-Rate tradeoff analysis.

**System Requirements**

To ensure the simulation runs correctly and within a reasonable timeframe, the following environment is required:

- **Processor:** Intel Core i7 (or equivalent high-performance CPU)
- **Operating System:** Windows 11
- **MATLAB Version:** R2025b

**Note:** The simulation involves complex noise integration and typically requires a minimum of 120 seconds of simulation time, which is computationally intensive.

**Prerequisites: MATLAB Toolboxes**

Ensure the following toolboxes are installed in your MATLAB environment:

- Mixed-Signal Blockset
- DSP System Toolbox
- Sigma-Delta Toolbox
- Filter Design Toolbox![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.002.png)

**Repository Structure Updated Repository Structure**

MATLAB\_SIMULINK :

DIGITAL\_FILTER\_FLOATING\_POINT\_REFERNCE

|-Compensation\_coefficients.m |-Halfband\_coefficeint.m FILTER\_SIMULINKMODELS

|-CIC.slx

|-COMPLETE\_FILTER.slx

|-FIR.slx

|-HALFBAND\_FIR.slx

MODULATOR\_Model\_SIMULINK

CT

|-ct\_ciff2\_ideal.slx |-ct\_ciff3\_ideal.slx |-ct\_ciff4\_ideal.slx DT

|-dt\_cifb2\_ideal.slx |-dt\_cifb3\_ideal.slx |-dt\_ciff2\_ideal.slx |-dt\_ciff3\_ideal.slx |-dt\_crfb2\_ideal.slx |-dt\_crfb3\_ideal.slx |-dt\_crff2\_ideal.slx |-dt\_crff3\_ideal.slx

hybrid\_2\_ideal.slx mash\_ideal.slx

FinalModel :

|-dt\_crfb3\_non\_ideal.slx

MATLAB\_SCRIPTS

|-slprj (cache files) |-Enob\_vs\_Samplingrate.m |-flicker.m |-thermal\_noise\_params.m |-getCIFBparams.m

Noise-Modelling NON\_IDEAL\_MODUALTORS\_SIMULINK

CT

|-ct\_ciff2\_non\_ideal.slx |-ct\_ciff3\_non\_ideal.slx |-ct\_ciff4\_non\_ideal.slx DT |-dt\_cifb2\_non\_ideal.slx |-dt\_cifb3\_non\_ideal.slx |-dt\_ciff2\_non\_ideal.slx |-dt\_ciff3\_non\_ideal.slx |-dt\_crfb2\_non\_ideal.slx |-dt\_crfb3\_non\_ideal.slx |-dt\_crff2\_non\_ideal.slx |-dt\_crff3\_non\_ideal.slx

hybrid\_2\_non\_ideal.slx mash\_non\_ideal.slx |-noise\_modelsimulink

OISE\_MODELS\_SIMULINK

|-clock\_jitter.slx |-CT\_NON\_IDEAL\_INTEGRATOR.slx |-DT\_NON\_IDEAL\_INTEGRATOR.slx |-flicker.slx

|-thermal\_noise.slx![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.003.png)

**Important: The Final Modulator**

The primary model chosen for evaluation is located in:

FinalModel/dt\_crfb3\_non\_ideal.slx

This is a \*\*Discrete-Time CRFB (Cascade of Resonators with FeedBack)\*\* 3rd-order modulator. It incorporates the following non-idealities (controlled via internal switches):

- **Flicker Noise**
- **Thermal Noise**
- **Clock Jitter**
- **Op-Amp Non-idealities:** Finite gain error ( ),*α* Slew rate, GBW, and Sampling period (*T s*).![ref1]

**Simulation Workflow**

Follow these steps strictly to reproduce the results.

**Step 1: Generate Digital Filter Coefficients**

Navigate to DIGITAL\_FILTER\_FLOATING\_POINT\_REFERENCE/ and run the following scripts to load coefficients into the workspace: 1. Compensation\_coefficients.m 2. Halfband\_coefficeint.m

**Step 2: Initialize Noise Models**

1. **Flicker Noise**

Run MATLAB\_SCRIPTS/flicker.m.

- Configures *F s* and *f corner* .
- Generates the state-space matrices for the Simulink 1/f filter block.
2. **Thermal Noise**

Run MATLAB\_SCRIPTS/thermal\_noise\_params.m.

- Inputs: Order, OSR, Target SNR, Temperature, Sampling Freq.
- Outputs: Sampling capacitor *C s* = *PnoisekT*~~ , Ideal SQNR, and Noise Power.

**Step 3: Run the Simulation (ENOB Analysis)**

To analyze the performance: 1. Open MATLAB\_SCRIPTS/Enob\_vs\_Samplingrate.m. 2. Ensure the script points to the correct model file (e.g., dt\_crfb3\_non\_ideal.slx). 3. Run the script.

The script will:

- Compute decimation factors and CIC scaling.
- Run the Simulink model for the specified duration (Default: num2str(Sim\_Time)).
- Extract adc\_ac\_out.
- Calculate SNR and ENOB.

**Results** will be stored in the OUT struct (e.g., OUT.out\_0p5k, OUT.out\_1k).![ref1]

**Critical Notes**

1. **Simulation Duration:** The minimum simulation time must be set to **120 seconds** to obtain valid SNR readings from the ADC-AC Measurement block.
1. **Output:** All numerical results (SNR/ENOB/SQNR) are printed directly to the MATLAB Command Window.

**Non-Ideality Modelling Blocks inside the modulators architecture of each non ideal file**

The following figures illustrate the Simulink implementations of each non-ideality used in the ∆Σ modulator.

![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.005.jpeg)

Figure 1: Non-Ideal Integrator Block (DT/CT Implementation)

![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.006.jpeg)

Figure 2: Alternate Op-Amp Non-Ideal Model (Internal Error Modelling)

![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.007.jpeg)

Figure 3: Thermal Noise Modelling Block

![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.008.jpeg)

Figure 4: Flicker Noise (1/f) Modelling Block

![](Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.009.jpeg)

Figure 5: Complete Non-Ideal ∆Σ Modulator Architecture

**How SNR is Computed in This Framework**

The Signal-to-Noise Ratio (SNR) evaluation is performed using the **ADC AC Measurement** block from the **Mixed-Signal Blockset**. This block internally uses a highly optimized FFT-based method to ensure accurate AC performance characterization of Delta-Sigma ADCs.

**Why the ADC AC Block is Used**

- MATLAB provides an optimized FFT engine that minimizes numerical leakage.
- The block automatically enforces **coherent sampling**, ensuring the input sinewave aligns perfectly with an FFT bin.
- The simulation stop time is automatically adjusted based on the output sampling rate and input tone frequency to avoid spectral leakage.
- The method is more reliable than manual FFT computation because it applies appropriate

  windowing, bin selection, and dynamic range scaling.

**FFT Bin Method Used Internally**

The ADC AC Measurement block computes SNR using the following process:

1. After decimation, the block collects a buffer of output samples.
1. Performs an *N*-point FFT over the captured data.
1. Identifies the **signal bin** corresponding to the input tone.
1. All other bins (except DC and harmonics) are treated as **noise**.

**SNR (dB)** = 10log *Psignal*

10 *Pnoise*

Where:

- *P signal* = FFT power in the tone bin.
- *P noise* = Total FFT power excluding the tone bin, DC, and harmonics.

**Coherent Sampling Enforcement**

To avoid spectral leakage:

*k*

*f* = *f in N s*

Where:

- *f in* = Input sine frequency given by the user.
- *f s* = Output sampling rate after decimation.
- *k* = Coherent integer bin index.

The ADC AC block automatically selects *N* and simulation stop time such that:

*f*

*in* = *k*

*fs N*

Thus the input waveform completes an integer number of cycles inside the FFT window.

**Advantages of This Method**

- Zero leakage in spectral bins.
- No need to manually tune the simulation time.
- Produces stable and repeatable SNR results.
- Works reliably with long simulation times (e.g., 120 seconds).

**Summary**

The ADC AC Measurement block ensures an accurate, robust SNR calculation by combining:

- Coherent sampling timing,
- Optimized FFT bin processing,
- Automatic noise floor separation,
- MATLAB’s internally enhanced DSP routines.

This makes it the preferred method for SNR and ENOB evaluation for your Delta-Sigma ADC architecture.

**Troubleshooting: Script Not Running**

If any problem occurs while running the main automation script (Enob\_vs\_Samplingrate.m)—for example, errors related to callbacks, initialization functions, model loading, or filter parameters— you can run the setup manually using the following procedure:

**Manual Run Procedure**

1. Choose the decimation factor manually. The decimation is always of the form: **Decimation Factor** = 64 × *D*

Set the multiplier:

*M* = 1

2. Provide the required modulator sampling frequency: **Fs\_mod**
2. Provide the input stimulus frequency:

   **inputF**

4. After setting these variables in the MATLAB workspace, you can run the model manually by entering the following command in the MATLAB Command Window:

   sim("D:\MATLAB\MATLAB\_SIMULINK\_MODELS\IDEAL\_MODULATORS\_SIMULINK\DT\dt\_crfb3\_ideal.slx",

’StopTime’, num2str(Sim\_Time));

This directly simulates the model for the duration specified by Sim\_Time.

This bypasses the automation script and forces Simulink to simulate the model using the parameters you manually supplied.
9

[ref1]: Aspose.Words.00a77f87-058c-433c-af95-26d3855c9fbc.004.png
