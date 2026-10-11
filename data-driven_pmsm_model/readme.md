## Hardware and System Parameters

The experimental setup utilizes a Texas Instruments C2000 microcontroller for motor control and a Lucas Nülle (LN) scope for data acquisition.

**PMSM Nameplate Data:**

* **Nominal current ($I_{nom}$):** 4.6 A


* **Nominal voltage ($U_{nom}$):** 165 V


* **Nominal speed ($n_{nom}$):** 4050 min$^{-1}$


* **Nominal power ($P_{nom}$):** 1000 W


* **Pole pairs ($p$):** 4


### 1. Initial Characterization & Calibration

* **Phase Resistance and Induced Voltage:** Initial measurements determine the phase resistance ($R_s$) using a multimeter and the induced voltage by driving the unconnected machine to 1000 min$^{-1}$.


* **Rotor Alignment:** The d-axis is aligned with the three-phase a-axis by applying a constant 15 V DC to phase a (`switch_voltage_mode = 0`). The resulting angle offset is compensated to zero the encoder.


* **CAN Bus Configuration:** Data transmission from the C2000 to the PC utilizes a 16-bit unsigned integer format ($0$ to $65536$). A constant offset of $32768$ is applied to allow the transmission of negative current values without complex bit-shifting.



### 2. Data Acquisition (Steady-State)

* **Current Combinations:** Seven $i_d$ and $i_q$ current combinations are selected within the maximum thermal limit ($I_{max} = 4.6\text{ A}$) to span the operational quadrant.


* **Automated Logging:** The PMSM is driven at a fixed speed of 400 min$^{-1}$ by the load machine. The C2000 state machine applies the target voltage vectors, waits for transient settling, and transmits the steady-state data. The `can_logger.py` script captures this data into a CSV file.



### 3. Flux Linkage & Inductance Mapping

Using the logged steady-state data, the flux linkages are computed by rearranging the standard dq-frame voltage equations:


$$u_d = R_s i_d - \omega_e \psi_q$$

$$u_q = R_s i_q + \omega_e \psi_d$$

* **Flux Maps:** The MATLAB script `calculate_flux_linkage_maps.m` removes the CAN offset, converts the data to double precision, and interpolates the seven measurement points into 2D grid surfaces for $\psi_d$ and $\psi_q$.


* **Inductance Calculation:** Both apparent inductance ($L_{app} = \psi/i$) and differential inductance ($L = d\psi/di$) are calculated across the grid using finite-difference gradients.



### 4. Transient Simulation & Validation

Two parallel Simulink models (`sim_pmsm.slx`) are evaluated against physical transient measurements:

1. **Constant Parameter Model (Linear):** Uses fixed inductance values.


2. **Flux Linkage Map Model (Non-linear):** Utilizes the interpolated 2D lookup tables derived from the steady-state measurements to account for core saturation.



The identical $u_{dq}$ voltage trajectories from the physical measurement are fed into both simulations. While both models perform accurately at low currents, the constant parameter model fails to accurately reflect the physical system at high currents due to magnetic saturation, whereas the non-linear flux map model successfully matches the measured current transients.

**NOTE**: The actual experiment files are not shared in the repository. 
