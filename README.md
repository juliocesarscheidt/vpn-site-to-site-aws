# AWS VPN site-to-site IAC project

This project is intended to deploy some resources on AWS to connect 2 or more VPCs through transit gateway routing with a VPN site-to-site connection.
The public subnet with the OpenSwan simulates an on-premises network, which closes the VPN connection with AWS.

## Architecture

![Architecture](./images/architecture.svg)
