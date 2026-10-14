# PMSM Torque Control and Flux-Weakening (FOC)

## Core Control Strategies

The drive's operating range is managed through two primary strategies depending on the motor speed and voltage limits:

* **Maximum Torque Per Current (MTPC):** Active at low speeds where the voltage limit is inactive. The OPS block identifies the operating point on the torque contour $T(i_{s,dq}) = T^*$ that has the smallest current amplitude $\vert{}\vert{}i_{s,dq}\vert{}\vert{}_2$, thereby minimizing copper losses.


* **Flux-Weakening (FW) & Modulation Control:** As the motor operates above base speed, the voltage limit ($u_{s,max}$) restricts the feasible operating region, making the MTPC point infeasible. A supervisory PI modulation controller forces the stator flux to decrease by pulling the d-axis current negative, keeping the required voltage within limits.



## Software Architecture and Implementation

### 1. Offline LUT Generation (`init_ex05.m`)

Before running the real-time simulation, offline MATLAB calculations generate the necessary maps based on non-linear flux data.

* Computes the current-limit circle and torque contours to extract the non-linear MTPC locus.


* Calculates voltage-limit ellipses across varying speeds (e.g., $0.5\omega_{nom}$, $\omega_{nom}$, and $1.5\omega_{nom}$).


* Generates a 1-D LUT for maximum achievable torque $T_{max}(\psi_{lim}^*)$ and 2-D LUTs for optimal $i_{s,d}^*$ and $i_{s,q}^*$ current references.



### 2. Operating Point Selection (OPS) Block (`ex05.slx`)

The Simulink subsystem processes the incoming torque command $T^*$ through the following sequence:

1. **Voltage Ceiling:** Calculates available flux $\psi_{avail} = u_{s,max}/\omega$.


2. **Flux Limiting:** Takes the minimum between the MTPC requested flux and the physically available flux.


3. **Torque Saturation:** Looks up the maximum achievable torque $T_{max}$ for the limited flux and clamps the requested torque to this boundary.


4. **Current Mapping:** Feeds the limited flux and torque values into the 2-D LUTs to output the optimal $(i_{s,d}^*, i_{s,q}^*)$ references.



### 3. Modulation Controller

A PI controller with an anti-reset windup (ARW) feedback loop actively monitors the inverter's modulation index $m$.

* During armature control (low speed), the controller remains saturated at its upper limit $\Delta\psi_{v,max}$.


* The integrator only activates when the modulation index approaches its limit ($m \ge m^* - \epsilon$), at which point it smoothly reduces the flux demand to transition into the flux-weakening region.



## Validation and Deployment

* **Simulation Verification:** The nonlinear PMSM model is tested with torque steps and speed ramps up to $1.5\omega_{nom}$. This verifies the seamless transition through all three operational phases: armature control, transition, and flux-weakening.


* **Hardware Testbench (C2000):** The generated C2000-ready Look-Up Tables (`ops_lut_c2000.mat`) are deployed to a Lucas Nülle (LN) testbench. Real-world validation confirms that the measured steady-state current amplitudes align with the MTPC locus predictions and tests the transient response behavior using different ARW gains under physical load constraints.
