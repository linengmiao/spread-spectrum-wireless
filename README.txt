The goal of this project is to send encrypted data wirelessly from a point A to B. In order to do so I
use a first FPGA which encrypts the data and puts it in a specific frame containing a preamble. 
This entire frame is then sent wirelessly through an RF antenna to another FPGA which detects the preamble, decrypts the data 
and renders it. 