# control-for-three-phase-drives
This repository houses my exercises and tutorials done as part of my university course. 

Exercise 1:

Developed and deployed an open-loop Field Oriented Control (FOC) algorithm for a Lucas Nuelle three-phase induction motor using the TI Delfino F2833x microcontroller, which is a model from C2000 family of microcontrollers. Focused on precise PWM generation and efficient motor phase modulation. <br>

Implementation include: <br>
1. A U/f-generation block to facilitate open-loop control. Inverse Park and Clarke transformations to manage the motor’s coordinate frame math. <br>
2. A PWM submodule designed to prepare signals for the inverter stage. <br>
3. Deployed the model in hardware and did oscilloscope measurements to verify switching frequency, voltage levels, duty cycle and modulation. <br>
4. Analyzed motor current and speed feedback to tune frequency ramp profiles. <br>

<img width="1129" height="522" alt="image" src="https://github.com/user-attachments/assets/39651ab5-8bef-4cfa-b65a-fdc0ec4c0bdb" /> <br>
Figure 1: Control architecture for the 3-phase induction motor, featuring coordinate transformation modules and a PWM sub-module. <br> 

[Source](https://github.com/abdul-kareem-mohamed/control-for-three-phase-drives/tree/main/openloop_FOC)

<img width="1200" height="1600" alt="WhatsApp Image 2026-05-12 at 16 55 10" src="https://github.com/user-attachments/assets/792dc491-4df9-48d7-a27d-05899eab5939" />
<img width="1200" height="1600" alt="WhatsApp Image 2026-05-12 at 16 55 10 (1)" src="https://github.com/user-attachments/assets/c7e793a1-641d-4a55-8dd9-9725ee43275e" />


Reference: <br>

https://github.com/IAS-Uni-Siegen/CTPD_course
