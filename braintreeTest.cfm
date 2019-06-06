<cfscript>
    /*
        Transaction amounts

        When working with transactions, you can pass specific amounts to simulate different processor responses. 
        Each test amount below will trigger the associated authorization response, regardless of the processing currency.

        Amount	            Authorization Response	                                            Settlement Response
        0.01 - 1999.99	    Authorized	                                                        Settled
        2000.00 - 2999.99	Processor Declined with a processor response equal to the amount	n/a
        3000.00 - 3000.99	Failed with a 3000 processor response	                            n/a
        3001.00 - 4000.99	Authorized	                                                        Settled
        4001.00 - 4001.99	Authorized	                                                        Settlement Declined on certain transaction types with 
                                                                                                    a processor response equal to the amount; Settled on all others
        4002.00 - 4002.99	Authorized	                                                        Settlement Pending on PayPal transactions with a processor 
                                                                                                    response equal to the amount; Settled on all others
        4003.00 - 5000.99	Authorized	                                                        Settlement Declined on certain transaction types with 
                                                                                                    a processor response equal to the amount; Settled on all others
        5001.00	            Gateway Rejected with a reason of Application Incomplete	        n/a
        5001.01	            Processor Declined on PayPal transactions in the Mocked             n/a on PayPal transactions; Settled on all others
                            PayPal flow with a 2038 processor response. Authorized on all 
                            others	            
        5001.02	            Authorized	                                                        Processor Unavailable on certain transaction types with 
                                                                                                    a processor response of 3000; Settled on all others
        5002.00 and up	    Authorized	                                                        Settled



        Valid card numbers

        These credit card numbers will not trigger specific credit card errors. However, this does not necessarily mean that 
        a transaction will be successful in the sandbox. Other values that impact transaction success include:

        - Transaction amount
        - AVS and CVV information (if using AVS and CVV rules)

        Test Value	            Card Type
        378282246310005	        American Express
        371449635398431	        American Express
        36259600000004	        Diners Club*
        6011111111111117	    Discover
        3530111333300000	    JCB
        6304000000000000	    Maestro
        5555555555554444	    Mastercard
        2223000048400011	    Mastercard
        4111111111111111	    Visa
        4005519200000004	    Visa
        4009348888881881	    Visa
        4012000033330026	    Visa
        4012000077777777	    Visa
        4012888888881881	    Visa
        4217651111111119	    Visa
        4500600000000061	    Visa


        Card numbers for unsuccessful verification

        The following credit card numbers will simulate an unsuccessful card verification response.


        Test Value	        Card Type	        Verification Response
        4000111111111115	Visa	            processor declined
        5105105105105100	Mastercard	        processor declined
        378734493671000	    American Express	processor declined
        6011000990139424	Discover	        processor declined
        38520000009814	    Diners Club*	    processor declined
        3566002020360505	JCB	                failed (3000)


        AVS and CVV/CID responses

        CVV/CID responses

        CVV	            CID (Amex)	        Response
        200	            2000	            N (does not match)
        201	            2011	            U (not verified)
        301	            3011	            S (issuer does not participate)
        no value passed	no value passed	    I (not provided)
        any other value	any other value	    M (matches)

        AVS error responses

        Billing Postal Code	        Response
        30000	                    E (AVS system error)
        30001	                    S (issuing bank does not support AVS)
        any other value	            blank

        AVS postal code responses

        Billing Postal Code	        Response
        20000	                    N (does not match)
        20001	                    U (not verified)
        no value passed	            I (not provided)
        any other value	            M (matches)

        AVS street address responses

        Billing Street Address	                    Response
        street number is 200 (e.g. 200 N Main St)	N (does not match)
        street number is 201 (e.g. 201 N Main St)	U (not verified)
        no value passed	                            I (not provided)
        any other value	                            M (matches)



        TEST TRANSACTION RESPONSES


        Good settlements (getTarget()):

        result.getTarget().getProcessorAuthorizationCode(): 7J2S4F
        result.getTarget().getProcessorResponseCode(): 1000
        result.getTarget().getProcessorResponseText(): Approved
        result.getTarget().getProcessorResponseType(): APPROVED
        result.getTarget().getProcessorSettlementResponseCode():
        result.getTarget().getProcessorSettlementResponseText():
        result.getTarget().getAdditionalProcessorResponse():
        result.getTarget().getAuthorizedTransactionId():
        getMessage():
                ----------------------------------
        ($3000.10)
        result.getTarget().getProcessorAuthorizationCode(): ZWLB8M
        result.getTarget().getProcessorResponseCode(): 1000
        result.getTarget().getProcessorResponseText(): Approved
        result.getTarget().getProcessorResponseType(): APPROVED
        result.getTarget().getProcessorSettlementResponseCode():
        result.getTarget().getProcessorSettlementResponseText():
        result.getTarget().getAdditionalProcessorResponse():
        result.getTarget().getAuthorizedTransactionId():
        getMessage(): 
                ----------------------------------
        ($4001.00)
        result.getTarget().getProcessorAuthorizationCode(): HX69T2
        result.getTarget().getProcessorResponseCode(): 1000
        result.getTarget().getProcessorResponseText(): Approved
        result.getTarget().getProcessorResponseType(): APPROVED
        result.getTarget().getProcessorSettlementResponseCode():
        result.getTarget().getProcessorSettlementResponseText():
        result.getTarget().getAdditionalProcessorResponse():
        result.getTarget().getAuthorizedTransactionId():
        getMessage(): 
                ----------------------------------
        ($5002.00)
        result.getTarget().getProcessorAuthorizationCode(): 2N938R
        result.getTarget().getProcessorResponseCode(): 1000
        result.getTarget().getProcessorResponseText(): Approved
        result.getTarget().getProcessorResponseType(): APPROVED
        result.getTarget().getProcessorSettlementResponseCode():
        result.getTarget().getProcessorSettlementResponseText():
        result.getTarget().getAdditionalProcessorResponse():
        result.getTarget().getAuthorizedTransactionId():
        getMessage(): 



        
        Bad settlements (getTransaction()):
        
        result.getTransaction().getProcessorAuthorizationCode():
        result.getTransaction().getProcessorResponseCode(): 2001
        result.getTransaction().getProcessorResponseText(): Insufficient Funds
        result.getTransaction().getProcessorResponseType(): SOFT_DECLINED
        result.getTransaction().getProcessorSettlementResponseCode():
        result.getTransaction().getProcessorSettlementResponseText():
        result.getTransaction().getAdditionalProcessorResponse(): 2001 : Insufficient Funds
        result.getTransaction().getAuthorizedTransactionId():
        getMessage(): Insufficient Funds
                ----------------------------------
        result.getTransaction().getProcessorAuthorizationCode():
        result.getTransaction().getProcessorResponseCode(): 3000
        result.getTransaction().getProcessorResponseText(): Processor Network Unavailable - Try Again
        result.getTransaction().getProcessorResponseType(): SOFT_DECLINED
        result.getTransaction().getProcessorSettlementResponseCode():
        result.getTransaction().getProcessorSettlementResponseText():
        result.getTransaction().getAdditionalProcessorResponse(): 3000 : Processor Network Unavailable - Try Again
        result.getTransaction().getAuthorizedTransactionId():
        getMessage(): Processor Network Unavailable - Try Again
                ----------------------------------
        ($5001.00)
        result.getTransaction().getProcessorAuthorizationCode():
        result.getTransaction().getProcessorResponseCode():
        result.getTransaction().getProcessorResponseText(): Unknown ()
        result.getTransaction().getProcessorResponseType():
        result.getTransaction().getProcessorSettlementResponseCode():
        result.getTransaction().getProcessorSettlementResponseText():
        result.getTransaction().getAdditionalProcessorResponse():
        result.getTransaction().getAuthorizedTransactionId():
        getMessage(): Gateway Rejected: application_incomplete


        For voids/refunds:

        Transaction transaction = gateway.transaction().find("the_transaction_id");

        if (transaction.getStatus() == Transaction.Status.SUBMITTED_FOR_SETTLEMENT) {
                // can void
        } else if (transaction.getStatus() == Transaction.Status.SETTLED) {
                // will have to refund it
        } else {
                // this example only expected one of the two above statuses
        }


    */
    authorization_response_codes = [
        {
            code = "1000",
            text = "Approved",
            description = ""
        },
        {
            code = "1001",
            text = "Approved, check customer ID",
            description = ""
        },
        {
            code = "1002",
            text = "Processed",
            description = "This code will be assigned to all refunds, credits, and voice authorizations. These types of transactions do not need to be authorized; they are immediately submitted for settlement."
        },
        {
            code = "1003",
            text = "Approved with Risk",
            description = "The bank account can be used for transactions, but some risk has been identified (e.g. some customer information does not exactly match the bank's records)."
        },
        {
            code = "2000",
            text = "Do Not Honor",
            description = "Your bank is unwilling to accept this transaction. Please contact your bank for more details.",
            decline_type = "Soft"
        },
        {
            code = "2001",
            text = "Insufficient Funds",
            description = "The account did not have sufficient funds to cover the transaction amount.",
            decline_type = "Soft"
        },
        {
            code = "2002",
            text = "Limit Exceeded",
            description = "The attempted transaction exceeds the withdrawal limit of the account. Please contact your bank to change the account limits or use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2003",
            text = "Cardholder's Activity Limit Exceeded",
            description = "The attempted transaction exceeds the activity limit of the account. Please contact your bank to change the account limits or use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2004",
            text = "Expired Card",
            description = "This card is expired. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2005",
            text = "Invalid Credit Card Number",
            description = "You entered an invalid payment method or made a typo in your card number. Please correct the payment information and attempt the transaction again – if the decline persists, contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2006",
            text = "Invalid Expiration Date",
            description = "You entered an invalid payment method or made a typo in your card expiration date. Please correct the payment information and attempt the transaction again – if the decline persists, contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2007",
            text = "No Account",
            description = "The submitted card number is not found with the card-issuing bank. Please contact their bank if you feel this in error.",
            decline_type = "Hard"
        },
        {
            code = "2008",
            text = "Card Account Length Error",
            description = "The submitted card number does not include the proper number of digits. Please try again – if the decline persists, contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2009",
            text = "No Such Issuer",
            description = "The submitted card number does not correlate to an existing card-issuing bank or that there is a connectivity error with the issuer. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2010",
            text = "Card Issuer Declined CVV",
            description = "You entered an invalid security code or made a typo in your card information. Please attempt the transaction again – if the decline persists, contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2011",
            text = "Voice Authorization Required",
            description = "Your bank is requesting that a call be made to obtain a special authorization code in order to complete this transaction. This can result in a lengthy process – we recommend using a different payment method instead or contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2012",
            text = "Processor Declined – Possible Lost Card",
            description = "The card used has likely been reported as lost. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2013",
            text = "Processor Declined – Possible Stolen Card",
            description = "The card used has likely been reported as stolen. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2014",
            text = "Processor Declined – Fraud Suspected",
            description = "Your bank suspects fraud – please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2015",
            text = "Transaction Not Allowed",
            description = "Your bank is declining the transaction for unspecified reasons, possibly due to an issue with the card itself. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2016",
            text = "Duplicate Transaction",
            description = "The submitted transaction appears to be a duplicate of a previously submitted transaction and was declined to prevent charging the same card twice for the same service.",
            decline_type = "Soft"
        },
        {
            code = "2017",
            text = "Cardholder Stopped Billing",
            description = "The customer requested a cancellation of a single transaction.",
            decline_type = "Hard"
        },
        {
            code = "2018",
            text = "Cardholder Stopped All Billing",
            description = "The customer requested the cancellation of a recurring transaction or subscription.",
            decline_type = "Hard"
        },
        {
            code = "2019",
            text = "Invalid Transaction",
            description = "Your bank declined the transaction, typically because the card in question does not support this type of transaction. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2020",
            text = "Violation",
            description = "Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2021",
            text = "Security Violation",
            description = "Your bank is declining the transaction, possibly due to a fraud concern. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2022",
            text = "Declined – Updated Cardholder Available",
            description = "The submitted card has expired or been reported lost and a new card has been issued.",
            decline_type = "Hard"
        },
        {
            code = "2023",
            text = "Processor Does Not Support This Feature",
            description = "We currently can't process transactions with the intended feature. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2024",
            text = "Card Type Not Enabled",
            description = "We currently cannot process this type of card. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2025",
            text = "Set Up Error – Merchant",
            description = "Or mercant account is not properly setup for this transaction.",
            decline_type = "Soft"
        },
        {
            code = "2026",
            text = "Invalid Merchant ID",
            description = "Your bank declined the transaction, typically because the card in question does not support this type of transaction.",
            decline_type = "Soft"
        },
        {
            code = "2027",
            text = "Set Up Error – Amount",
            description = "There is an issue with processing the amount of the transaction.",
            decline_type = "Hard"
        },
        {
            code = "2028",
            text = "Set Up Error – Hierarchy",
            description = "There is an issue with our payment processor account.",
            decline_type = "Hard"
        },
        {
            code = "2029",
            text = "Set Up Error – Card",
            description = "There is a problem with the submitted card. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2030",
            text = "Set Up Error – Terminal",
            description = "There is an issue with our payment processor account.",
            decline_type = "Hard"
        },
        {
            code = "2031",
            text = "Encryption Error",
            description = "Your bank does not support $0.00 card verifications.",
            decline_type = "Hard"
        },
        {
            code = "2032",
            text = "Surcharge Not Permitted",
            description = "Surcharge amount not permitted on this card. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2033",
            text = "Inconsistent Data",
            description = "An error occurred when communicating with the processor. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2034",
            text = "No Action Taken",
            description = "An error occurred and the intended transaction was not completed. Please try again or use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2035",
            text = "Partial Approval For Amount In Group III Version",
            description = "There were AVS issues with the transaction. Please try again or use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2036",
            text = "Authorization could not be found",
            description = "An error occurred when trying to process the authorization. There is either an issue with your card or the processor doesn't allow this action.",
            decline_type = "Hard"
        },
        {
            code = "2037",
            text = "Already Reversed",
            description = "The indicated authorization has already been reversed.",
            decline_type = "Hard"
        },
        {
            code = "2038",
            text = "Processor Declined",
            description = "Your bank is unwilling to accept the transaction. The reasons for this response can vary – please contact your bank for more information.",
            decline_type = "Soft"
        },
        {
            code = "2039",
            text = "Invalid Authorization Code",
            description = "The authorization code was not found or not provided. Please attempt the transaction again – if the decline persists, contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2040",
            text = "Invalid Store",
            description = "There may be an issue with the configuration of our account. Please attempt the transaction again – if the decline persists, contact us with this error code: 2040.",
            decline_type = "Soft"
        },
        {
            code = "2041",
            text = "Declined – Call For Approval",
            description = "The card used for this transaction requires customer approval – please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2042",
            text = "Invalid Client ID",
            description = "There may be an issue with the configuration of our account. Please attempt the transaction again – if the decline persists, contact us with this error code: 2042.",
            decline_type = "Soft"
        },
        {
            code = "2043",
            text = "Error – Do Not Retry, Call Issuer",
            description = "The card-issuing bank will not allow this transaction. Please contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2044",
            text = "Declined – Call Issuer",
            description = "The card-issuing bank has declined this transaction. Please attempt the transaction again – if the decline persists, you will need to contact your bank for more information.",
            decline_type = "Hard"
        },
        {
            code = "2045",
            text = "Invalid Merchant Number",
            description = "There is a setup issue with our account. Please attempt the transaction again - if the decline persists, contact us with this error code: 2045.",
            decline_type = "Hard"
        },
        {
            code = "2046",
            text = "Declined",
            description = "Your bank is unwilling to accept this transaction. Please contact your bank for more details regarding this decline.",
            decline_type = "Soft"
        },
        {
            code = "2047",
            text = "Call Issuer. Pick Up Card",
            description = "This card has been reported as lost or stolen by the cardholder, and the card-issuing bank has requested that merchants report it.  Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2048",
            text = "Invalid Amount",
            description = "The authorized amount is set to zero, is unreadable, or exceeds the allowable amount. Make sure the amount is greater than zero and in a suitable format.",
            decline_type = "Soft"
        },
        {
            code = "2049",
            text = "Invalid SKU Number",
            description = "A non-numeric value was sent with the attempted transaction. Fix errors and resubmit with the transaction with the proper SKU Number.",
            decline_type = "Hard"
        },
        {
            code = "2050",
            text = "Invalid Credit Plan",
            description = "There may be an issue with your card or a temporary issue at the card-issuing bank. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2050",
            text = "Invalid Credit Plan",
            description = "There may be an issue with your card or a temporary issue at the card-issuing bank. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2051",
            text = "Credit Card Number does not match method of payment",
            description = "There may be an issue with the your credit card or a temporary issue at the card-issuing bank. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2053",
            text = "Card reported as lost or stolen",
            description = "The card used has been reported lost or stolen. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2054",
            text = "Reversal amount does not match authorization amount",
            description = "Either the refund amount is greater than the original transaction or the card-issuing bank does not allow partial refunds. Please contact your bank for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2055",
            text = "Invalid Transaction Division Number",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2056",
            text = "Transaction amount exceeds the transaction division limit",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2057",
            text = "Issuer or Cardholder has put a restriction on the card",
            description = "The card was declined due to a cardholder restriction on the card. Please contact your bank for more information or use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2058",
            text = "Merchant not Mastercard SecureCode enabled",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2059",
            text = "Address Verification Failed",
            description = "PayPal was unable to verify that the transaction qualifies for Seller Protection because the address was improperly formatted. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2060",
            text = "Address Verification and Card Security Code Failed",
            description = "Both the AVS and CVV checks failed for this transaction. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2061",
            text = "Invalid Transaction Data",
            description = "There may be an issue with your card or a temporary issue at the card-issuing bank. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2062",
            text = "Invalid Tax Amount",
            description = "There may be an issue with your card or a temporary issue at the card-issuing bank. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2063",
            text = "PayPal Business Account preference resulted in the transaction failing",
            description = "We can't process this transaction because this account is set to block certain payment types, such as eChecks or foreign currencies.",
            decline_type = "Hard"
        },
        {
            code = "2064",
            text = "Invalid Currency Code",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2064.",
            decline_type = "Hard"
        },
        {
            code = "2065",
            text = "Refund Time Limit Exceeded",
            description = "PayPal requires that refunds are issued within 180 days of the sale. This refund can't be successfully processed.",
            decline_type = "Hard"
        },
        {
            code = "2066",
            text = "PayPal Business Account Restricted",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2066.",
            decline_type = "Hard"
        },
        {
            code = "2067",
            text = "Authorization Expired",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2067.",
            decline_type = "Hard"
        },
        {
            code = "2068",
            text = "PayPal Business Account Locked or Closed",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2068.",
            decline_type = "Hard"
        },
        {
            code = "2069",
            text = "PayPal Blocking Duplicate Order IDs",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2069.",
            decline_type = "Hard"
        },
        {
            code = "2070",
            text = "PayPal Buyer Revoked Pre-Approved Payment Authorization",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2070.",
            decline_type = "Hard"
        },
        {
            code = "2071",
            text = "PayPal Payee Account Invalid Or Does Not Have a Confirmed Email",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2071.",
            decline_type = "Hard"
        },
        {
            code = "2072",
            text = "PayPal Payee Email Incorrectly Formatted",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2072.",
            decline_type = "Hard"
        },
        {
            code = "2073",
            text = "PayPal Validation Error",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2073.",
            decline_type = "Hard"
        },
        {
            code = "2074",
            text = "Funding Instrument In The PayPal Account Was Declined By The Processor Or Bank, Or It Can't Be Used For This Payment",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2075",
            text = "Payer Account Is Locked Or Closed",
            description = "Your PayPal account can't be used for transactions at this time. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2076",
            text = "Payer Cannot Pay For This Transaction With PayPal",
            description = "Your PayPal account can't be used for transactions at this time. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2077",
            text = "Transaction Refused Due To PayPal Risk Model",
            description = "PayPal has declined this transaction due to risk limitations. Please contact PayPal’s Support team to resolve this issue.",
            decline_type = "Hard"
        },
        {
            code = "2079",
            text = "PayPal Merchant Account Configuration Error",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2081",
            text = "PayPal pending payments are not supported",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2082",
            text = "PayPal Domestic Transaction Required",
            description = "This transaction requires you to be a resident of the same country as the merchant. Please attempt the transaction again – if the decline persists, use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2083",
            text = "PayPal Phone Number Required",
            description = "This transaction requires you to provide a valid phone number. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2084",
            text = "PayPal Tax Info Required",
            description = "This transaction requires you to complete your PayPal account information, including a phone number and all required tax information. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2085",
            text = "PayPal Payee Blocked Transaction",
            description = "An error occurred when trying to process the transaction based on fraud settings. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2086",
            text = "PayPal Transaction Limit Exceeded",
            description = "The settings on your PayPal account do not allow a transaction amount this large. Please contact PayPal for more information or use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2087",
            text = "PayPal reference transactions not enabled for your account",
            description = "An error occurred when trying to process the transaction based on fraud settings. Please use a different payment method.",
            decline_type = "Hard"
        },
        {
            code = "2088",
            text = "Currency not enabled for your PayPal seller account",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2088.",
            decline_type = "Hard"
        },
        {
            code = "2089",
            text = "PayPal payee email permission denied for this request",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2089.",
            decline_type = "Hard"
        },
        {
            code = "2090",
            text = "PayPal account not configured to refund more than settled amount",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2090.",
            decline_type = "Hard"
        },
        {
            code = "2091",
            text = "Currency of this transaction must match currency of your PayPal account",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2091.",
            decline_type = "Hard"
        },
        {
            code = "2092",
            text = "No Data Found - Try Another Verification Method",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2092.",
            decline_type = "Soft"
        },
        {
            code = "2093",
            text = "PayPal payment method is invalid",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2093.",
            decline_type = "Hard"
        },
        {
            code = "2094",
            text = "PayPal payment has already been completed",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2094.",
            decline_type = "Hard"
        },
        {
            code = "2095",
            text = "PayPal refund is not allowed after partial refund",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2095.",
            decline_type = "Hard"
        },
        {
            code = "2096",
            text = "PayPal buyer account can't be the same as the seller account",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2096.",
            decline_type = "Hard"
        },
        {
            code = "2097",
            text = "PayPal authorization amount limit exceeded",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2097.",
            decline_type = "Hard"
        },
        {
            code = "2098",
            text = "PayPal authorization count limit exceeded",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2098.",
            decline_type = "Hard"
        },
        {
            code = "2099",
            text = "Cardholder Authentication Required",
            description = "Your bank declined the transaction because a secure authentication was not performed during checkout. Please use a different payment method.",
            decline_type = "Soft"
        },
        {
            code = "2100",
            text = "PayPal channel initiated billing not enabled for your account",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2100.",
            decline_type = "Hard"
        },
        {
            code = "2100",
            text = "PayPal channel initiated billing not enabled for your account",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again - if the decline persists, please contact us with this error code: 2100.",
            decline_type = "Hard"
        },
        {
            code = "2101",
            text = "Processor Declined",
            description = "Your bank is unwilling to accept the transaction. Please contact their bank for more details regarding this decline.",
            decline_type = "Soft",
            range_end = "2999"
        },
        {
            code = "3000",
            text = "Processor Network Unavailable – Try Again",
            description = "An error occurred when trying to process the transaction. Please attempt the transaction again in a few moments - if the decline persists, please contact us with this error code: 3000.",
            decline_type = "Soft"
        }
    ]

    avs_address_response_codes = [
        {
            code = "M",
            response = "Street Address matches (M)",
            description = "The street address provided matches the information on file with the cardholder's bank."
        },
        {
            code = "N",
            response = "Street Address does not match (N)",
            description = "The street address provided does not match the information on file with the cardholder's bank."
        },
        {
            code = "U",
            response = "Street Address not verified (U)",
            description = "The card-issuing bank received the street address but did not verify whether it was correct. This typically happens if the processor declines an authorization before the bank evaluates the address."
        },
        {
            code = "I",
            response = "Street Address not provided (I)",
            description = "No street address was provided."
        },
        {
            code = "S",
            response = "Issuing bank does not support AVS (S)",
            description = "AVS information was provided but the card-issuing bank does not participate in address verification. This typically indicates a card-issuing bank outside of the US, Canada, and the UK."
        },
        {
            code = "E",
            response = "AVS system error (E)",
            description = "A system error prevented any verification of street address or postal code."
        },
        {
            code = "A",
            response = "AVS not applicable (A)",
            description = "AVS information was provided but this type of transaction does not support address verification."
        },
        {
            code = "B",
            response = "AVS skipped (B)",
            description = "AVS checks were skipped for this transaction."
        }
    ]

    avs_postalcode_response_codes = [
        {
            code = "M",
            response = "Postal Code matches (M)",
            description = "The postal code provided matches the information on file with the cardholder's bank."
        },
        {
            code = "N",
            response = "Postal Code does not match (N)",
            description = "The postal code provided does not match the information on file with the cardholder's bank."
        },
        {
            code = "U",
            response = "Postal Code not verified (U)",
            description = "The card-issuing bank received the postal code but did not verify whether it was correct. This typically happens if the processor declines an authorization before the bank evaluates the postal code."
        },
        {
            code = "I",
            response = "Postal Code not provided (I)",
            description = "No postal code was provided."
        },
        {
            code = "S",
            response = "Issuing bank does not support AVS (S)",
            description = "AVS information was provided but the card-issuing bank does not participate in address verification. This typically indicates a card-issuing bank outside of the US, Canada, and the UK."
        },
        {
            code = "E",
            response = "AVS system error (E)",
            description = "A system error prevented any verification of street address or postal code."
        },
        {
            code = "A",
            response = "AVS not applicable (A)",
            description = "AVS information was provided but this type of transaction does not support address verification."
        },
        {
            code = "B",
            response = "AVS skipped (B)",
            description = "AVS checks were skipped for this transaction."
        }
    ]

    cvv_response_codes = [
        {
            code = "M",
            response = "CVV matches (M)",
            description = "The CVV provided matches the information on file with the cardholder's bank."
        },
        {
            code = "N",
            response = "CVV does not match (N)",
            description = "The CVV provided does not match the information on file with the cardholder's bank."
        },
        {
            code = "U",
            response = "CVV is not verified (U)",
            description = "The card-issuing bank received the CVV, but did not verify whether it was correct. This typically happens if the bank declines an authorization before evaluating the CVV."
        },
        {
            code = "I",
            response = "CVV not provided (I)",
            description = "No CVV was provided. This also happens if the transaction was made with a vaulted payment method."
        },
        {
            code = "S",
            response = "Issuer does not participate (S)",
            description = "The CVV was provided but the card-issuing bank does not participate in card verification."
        },
        {
            code = "A",
            response = "CVV not applicable (A)",
            description = "The CVV was provided but this type of transaction does not support card verification."
        },
        {
            code = "B",
            response = "CVV skipped (B)",
            description = "CVV checks were skipped for this transaction."
        }
    ]

    try {
        jstr = function (cfml_string) { return javaCast("java.lang.String", cfml_string) };

        env = createObject("java", "com.braintreegateway.Environment", "/jars/braintree-java-2.96.0.jar");
        gw = createObject("java", "com.braintreegateway.BraintreeGateway", "/jars/braintree-java-2.96.0.jar").init(
            env.Sandbox,
            jstr("9dcqy4pjq3v4m4tq"),
            jstr("jyqr36f7kx2qsmfx"),
            jstr("77dd270249a6fde850d933d84cd9424d")
        );

        acct = gw.merchantAccount().find(jstr("eventsregistrationllc"));
        
        if ( acct.getStatus().name() == "ACTIVE" ) {
            trans_request = createObject("java", "com.braintreegateway.TransactionRequest", "/jars/braintree-java-2.96.0.jar");

            credit_card_request = trans_request
                .amount(javacast("bigdecimal", 5076.00))
                .orderId(jstr("TESTORDER-76"))
                .merchantAccountId(acct.getId())
                .customField("trackingnumber", "11176")
                .customField("event", "E-vents Registration Test Event")
                .customer()
                    .firstName(jstr("Joe"))
                    .lastName(jstr("Smith"))
                    .company(jstr("E-vents Registration"))
                    .email(jstr("drew@example.com"))
                    .done()
                .creditCard()
                    .number(jstr("4217651111111119"))
                    .cvv(jstr("999"))
                    .expirationDate(jstr("03/22"))
                    .cardholderName(jstr("Joe S. Smith"))
                    .done()
                .billingAddress()
                    .firstName(jstr("Joe"))
                    .lastName(jstr("Smith"))
                    .company(jstr("E-vents Registration"))
                    .streetAddress(jstr("999 N Main St"))
                    .locality(jstr("Chicago"))
                    .region(jstr("IL"))
                    .postalCode(jstr("12121"))
                    .countryCodeAlpha2(jstr("US"))
                    .done()
                .options()
                    .submitForSettlement(true)
                    .done();

            result = gw.transaction().sale(credit_card_request);

            if ( result.getTransaction() === Null ) {
                if ( result.getTarget() === Null ) {
                    echo("
                        <div>
                            getMessage():
                            <div>#result.getMessage()#</div>
                        </div>
                    ");
                } else {
                    echo("
                        <div>
                            <div>
                                result.getTarget().getProcessorAuthorizationCode():
                                <div>#result.getTarget().getProcessorAuthorizationCode()#</div>
                            </div>
                            <div>
                                result.getTarget().getProcessorResponseCode():
                                <div>#result.getTarget().getProcessorResponseCode()#</div>
                            </div>
                            <div>
                                result.getTarget().getProcessorResponseText():
                                <div>#result.getTarget().getProcessorResponseText()#</div>
                            </div>
                            <div>
                                result.getTarget().getProcessorResponseType():
                                <div>#result.getTarget().getProcessorResponseType()#</div>
                            </div>
                            <div>
                                result.getTarget().getProcessorSettlementResponseCode():
                                <div>#result.getTarget().getProcessorSettlementResponseCode()#</div>
                            </div>
                            <div>
                                result.getTarget().getProcessorSettlementResponseText():
                                <div>#result.getTarget().getProcessorSettlementResponseText()#</div>
                            </div>
                            <div>
                                result.getTarget().getAdditionalProcessorResponse():
                                <div>#result.getTarget().getAdditionalProcessorResponse()#</div>
                            </div>
                            <div>
                                result.getTarget().getAuthorizedTransactionId():
                                <div>#result.getTarget().getAuthorizedTransactionId()#</div>
                            </div>
                            <div>
                                result.getTarget().getCvvResponseCode():
                                <div>#result.getTarget().getCvvResponseCode()#</div>
                            </div>
                            <div>
                                result.getTarget().getAvsPostalCodeResponseCode():
                                <div>#result.getTarget().getAvsPostalCodeResponseCode()#</div>
                            </div>
                            <div>
                                result.getTarget().getAvsStreetAddressResponseCode():
                                <div>#result.getTarget().getAvsStreetAddressResponseCode()#</div>
                            </div>
                            <div>
                                getMessage():
                                <div>#result.getMessage()#</div>
                            </div>
                        </div>  
                    ");
                }           
            } else {
                echo("
                    <div>
                        <div>
                            result.getTransaction().getProcessorAuthorizationCode():
                            <div>#result.getTransaction().getProcessorAuthorizationCode()#</div>
                        </div>
                        <div>
                            result.getTransaction().getProcessorResponseCode():
                            <div>#result.getTransaction().getProcessorResponseCode()#</div>
                        </div>
                        <div>
                            result.getTransaction().getProcessorResponseText():
                            <div>#result.getTransaction().getProcessorResponseText()#</div>
                        </div>
                        <div>
                            result.getTransaction().getProcessorResponseType():
                            <div>#result.getTransaction().getProcessorResponseType()#</div>
                        </div>
                        <div>
                            result.getTransaction().getProcessorSettlementResponseCode():
                            <div>#result.getTransaction().getProcessorSettlementResponseCode()#</div>
                        </div>
                        <div>
                            result.getTransaction().getProcessorSettlementResponseText():
                            <div>#result.getTransaction().getProcessorSettlementResponseText()#</div>
                        </div>
                        <div>
                            result.getTransaction().getAdditionalProcessorResponse():
                            <div>#result.getTransaction().getAdditionalProcessorResponse()#</div>
                        </div>
                        <div>
                            result.getTransaction().getAuthorizedTransactionId():
                            <div>#result.getTransaction().getAuthorizedTransactionId()#</div>
                        </div>
                        <div>
                            result.getTransaction().getCvvResponseCode():
                            <div>#result.getTransaction().getCvvResponseCode()#</div>
                        </div>
                        <div>
                            result.getTransaction().getAvsPostalCodeResponseCode():
                            <div>#result.getTransaction().getAvsPostalCodeResponseCode()#</div>
                        </div>
                        <div>
                            result.getTransaction().getAvsStreetAddressResponseCode():
                            <div>#result.getTransaction().getAvsStreetAddressResponseCode()#</div>
                        </div>
                        <div>
                            getMessage():
                            <div>#result.getMessage()#</div>
                        </div>
                    </div>  
                ");
            }

            dump(result.isSuccess());
            dump(result.getErrors() !== Null ? result.getErrors() : "no errors");

            transaction = result.getTransaction() === Null ? result.getTarget() : result.getTransaction();

            gw.testing().settle(transaction.getId());

            refund = gw.transaction().refund(transaction.getId());
            refund_transaction = refund.getTransaction() === Null ? refund.getTarget() : refund.getTransaction();
            
            dump(refund);
            dump(refund_transaction);

        } else {
            echo("the sandbox account is not active");
        }
    } catch (Any e) {
        dump(e);
    }
</cfscript>
