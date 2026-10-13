# Field-Oriented Current Controller (FOCC) for PMSM

## Hardware Specifications

The experimental setup utilizes a PMSM with the following nominal parameters:

| Parameter | Symbol | Value |
| --- | --- | --- |
| Nominal phase current | $i_{nom}$ | 4.6 A |
| Nominal phase-to-phase voltage | $u_{nom}$ | 165 V |
| Nominal speed | $n_{nom}$ | 4050 min$^{-1}$ |
| Nominal power | $P_{nom}$ | 1000 W |
| Pole pairs | $p$ | 4 |
| Phase resistance | $R_s$ | 0.9 Ω |
| Inductances | $L_{dd}, L_{qq}$ | 3.2 mH |
| Permanent magnet flux linkage | $\psi_{PM}$ | 85 mVs |

## Controller Architecture

The FOC structure is built within a provided Simulink model and consists of three primary components:

* **Model Prediction:** Performs a one-step prediction based on the machine model to estimate the current at the exact time of the controller output update.


* **MIMO Decoupling:** Uses a feedforward block to decouple the multiple-input multiple-output (MIMO) system into two independent single-input single-output (SISO) current dynamics systems.


* **Feedback Controller with Prefilter:** Decomposes the controller action into a PI feedback controller path and a parallel reference prefilter path.


* **Anti-Reset Windup (ARW):** Implements a scheme to prevent the uncontrolled runaway of the integral state, which can occur in practice due to the limited DC-link voltage and the applied modulation technique.



## Simulation and Experimental Verification

The controller is strictly tested in a simulated environment before hardware deployment to prevent system damage.

* **Measurement Tools:** Experimental transient current responses are recorded using a Lucas Nülle (LN) scope, utilizing standard trigger and single-shot functions to capture clean reference steps. Data is exported via CSV for MATLAB analysis.


* **Parameter Tuning:** The system's behavior is analyzed by applying various current reference steps while modifying the plant parameter $\alpha$ and the controller tuning parameters $d$ and $p$. System robustness is further verified by actively turning the prediction, decoupling, and ARW features on and off.


* **Flux Linkage Mapping:** Following the controller verification, the FOC is used to record flux linkage maps. The load machine is accelerated to a high speed below the nominal speed to minimize measurement uncertainty, and current operating points are selected to equally distribute across the operating range.


* **Data Logging:** Real-time logging of the identification and measurement process is handled by executing the `can_logger.py` Python script in Visual Studio Code.
