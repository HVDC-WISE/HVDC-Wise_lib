# HVDC-Wise lib

HVDC-Wise lib hosts a library of HVDC equipment models for model exchange, based on the IEC CIM/CGMES standard format. For the purpose of standardized model exchange, the models in the library are split into a *static part* and a *dynamic part*: 
- For the *static part* of a model, the data are exchanged, e.g., model topology and equipment parameters. 
- For the *dynamic part* of a model, the actual model equations and optionally even a solver are exchanged.

## Structure

- [Data_exchange](Data_exchange/) contains extentions for IEC CIM and IEC CGMES profiles to support data modelling and exchange of the *static part* of the library's models.
- [Equations_exchange](Equations_exchange/) contains model equations to support exchange of the *dynamic part* of the libary's models.
- [Documentation](Documentation) contains documentation for the library models and resources, supporting documentation (e.g. [Images](Documentation/Resources/Images/) or [Templates](Documentation/Resources/Templates/)).

## Usage

-  **TODO:** Provide instructions on how to use HVDC-Wise lib.

## Contributing

 - **TODO:** Provide instructions on how to contribute to HVDC-Wise lib.

 ![Workflow to contribute model](Documentation/Resources/Images/workflow.svg "Workflow to contribute model")

 ## License

 - **TODO:** Review https://choosealicense.com/

HVDC-Wise lib is licensed under the [CC-BY-4.0](LICENSE).

## Contact

 - **TODO:** Add contact information.

 ## Acknowledgement
HVDC-Wise lib is developed as a part of the HVDC-WISE project.

HVDC-WISE is supported by the European Union’s Horizon Europe programme under agreement 101075424.

UK Research and Innovation (UKRI) funding for HVDC-WISE is provided under the UK government’s Horizon Europe funding guarantee [grant numbers 10041877 and 10051113].