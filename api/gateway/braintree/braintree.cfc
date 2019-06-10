component displayname="Braintree Interface" extends="cfpayment.api.gateway.base" {
	variables.cfpayment.GATEWAY_NAME = "Braintree";
	variables.cfpayment.GATEWAY_VERSION = "2.96.0"; // uses Java SDK 2.96.0

	variables.authorization_response_codes = [
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

	variables.avs_address_response_codes = [
		{
			code = "M",
			response = "Street Address matches (M)",
			description = "The street address provided matches the information on file with the cardholder's bank.",
			passes = true
		},
		{
			code = "N",
			response = "Street Address does not match (N)",
			description = "The street address provided does not match the information on file with the cardholder's bank.",
			passes = false
		},
		{
			code = "U",
			response = "Street Address not verified (U)",
			description = "The card-issuing bank received the street address but did not verify whether it was correct. This typically happens if the processor declines an authorization before the bank evaluates the address.",
			passes = true
		},
		{
			code = "I",
			response = "Street Address not provided (I)",
			description = "No street address was provided.",
			passes = true
		},
		{
			code = "S",
			response = "Issuing bank does not support AVS (S)",
			description = "AVS information was provided but the card-issuing bank does not participate in address verification. This typically indicates a card-issuing bank outside of the US, Canada, and the UK.",
			passes = true
		},
		{
			code = "E",
			response = "AVS system error (E)",
			description = "A system error prevented any verification of street address or postal code.",
			passes = true
		},
		{
			code = "A",
			response = "AVS not applicable (A)",
			description = "AVS information was provided but this type of transaction does not support address verification.",
			passes = true
		},
		{
			code = "B",
			response = "AVS skipped (B)",
			description = "AVS checks were skipped for this transaction.",
			passes = true
		}
	]

	variables.avs_postalcode_response_codes = [
		{
			code = "M",
			response = "Postal Code matches (M)",
			description = "The postal code provided matches the information on file with the cardholder's bank.",
			passes = true
		},
		{
			code = "N",
			response = "Postal Code does not match (N)",
			description = "The postal code provided does not match the information on file with the cardholder's bank.",
			passes = false
		},
		{
			code = "U",
			response = "Postal Code not verified (U)",
			description = "The card-issuing bank received the postal code but did not verify whether it was correct. This typically happens if the processor declines an authorization before the bank evaluates the postal code.",
			passes = true
		},
		{
			code = "I",
			response = "Postal Code not provided (I)",
			description = "No postal code was provided.",
			passes = true
		},
		{
			code = "S",
			response = "Issuing bank does not support AVS (S)",
			description = "AVS information was provided but the card-issuing bank does not participate in address verification. This typically indicates a card-issuing bank outside of the US, Canada, and the UK.",
			passes = true
		},
		{
			code = "E",
			response = "AVS system error (E)",
			description = "A system error prevented any verification of street address or postal code.",
			passes = true
		},
		{
			code = "A",
			response = "AVS not applicable (A)",
			description = "AVS information was provided but this type of transaction does not support address verification.",
			passes = true
		},
		{
			code = "B",
			response = "AVS skipped (B)",
			description = "AVS checks were skipped for this transaction.",
			passes = true
		}
	]

	variables.cvv_response_codes = [
		{
			code = "M",
			response = "CVV matches (M)",
			description = "The CVV provided matches the information on file with the cardholder's bank.",
			passes = true
		},
		{
			code = "N",
			response = "CVV does not match (N)",
			description = "The CVV provided does not match the information on file with the cardholder's bank.",
			passes = false
		},
		{
			code = "U",
			response = "CVV is not verified (U)",
			description = "The card-issuing bank received the CVV, but did not verify whether it was correct. This typically happens if the bank declines an authorization before evaluating the CVV.",
			passes = true
		},
		{
			code = "I",
			response = "CVV not provided (I)",
			description = "No CVV was provided. This also happens if the transaction was made with a vaulted payment method.",
			passes = false
		},
		{
			code = "S",
			response = "Issuer does not participate (S)",
			description = "The CVV was provided but the card-issuing bank does not participate in card verification.",
			passes = true
		},
		{
			code = "A",
			response = "CVV not applicable (A)",
			description = "The CVV was provided but this type of transaction does not support card verification.",
			passes = true
		},
		{
			code = "B",
			response = "CVV skipped (B)",
			description = "CVV checks were skipped for this transaction.",
			passes = true
		}
	]

	private any function process(required struct payload, struct options = {}) {
		service = getService();
		response_args = { 
			Status = service.getStatusPending(), 
			StatusCode = "", 
			Result = "", 
			Message = "", 
			RequestData = getTestMode() ? { payload = duplicate(payload) } : {}, 
			TestMode = getTestMode() 
		}

		response = createObject("component", "cfpayment.api.model.response").init(argumentCollection = response_args, service = service);

		try {
			env = createObject("java", "com.braintreegateway.Environment", "/jars/braintree-java-2.96.0.jar");

			if ( response_args.TestMode ) {
				gw = createObject("java", "com.braintreegateway.BraintreeGateway", "/jars/braintree-java-2.96.0.jar").init(
					env.Sandbox,
					getMerchantId(),
					getPublicKey(),
					getPrivateKey()
				);
			} else {
				gw = createObject("java", "com.braintreegateway.BraintreeGateway", "/jars/braintree-java-2.96.0.jar").init(
					env.Production,
					getMerchantId(),
					getPublicKey(),
					getPrivateKey()
				);
			}

			acct = gw.merchantAccount().find(getMerchantAccountId());

			if ( acct.getStatus().name() == "ACTIVE" ) {
				if ( payload.type == "sale" ) {
					trans_request = createObject("java", "com.braintreegateway.TransactionRequest", "/jars/braintree-java-2.96.0.jar");
		
					credit_card_request = trans_request
						.amount(javacast("bigdecimal", val(payload.amount)))
						.orderId(options.keyExists("orderID") ? jstr(options.orderID) : jstr(""))
						.merchantAccountId(acct.getId())
						.customer()
							.firstName(jstr(payload.firstname))
							.lastName(jstr(payload.lastname))
							.company(jstr(payload.company))
							.email(jstr(payload.email))
							.done()
						.creditCard()
							.number(jstr(payload.ccnumber))
							.cvv(jstr(payload.cvv))
							.expirationDate(jstr(payload.ccexp))
							.cardholderName(jstr(payload.cardholderName))
							.done()
						.billingAddress()
							.firstName(jstr(payload.firstname))
							.lastName(jstr(payload.lastname))
							.company(jstr(payload.company))
							.streetAddress(jstr(payload.address))
							.locality(jstr(payload.locality))
							.region(jstr(payload.region))
							.postalCode(jstr(payload.postalcode))
							.countryCodeAlpha2(jstr(payload.countryCode))
							.done()
						.options()
							.submitForSettlement(true)
							.done();
		
					result = gw.transaction().sale(credit_card_request); // sending to the Braintree gateway
					transaction = result.getTransaction() === Null ? result.getTarget() : result.getTransaction(); // depending on response, transaction object could be getTransaction() or getTarget()

					response_code_message = variables.authorization_response_codes.filter(function(code) {
						return code.code == transaction.getProcessorResponseCode()
					}).reduce(function(init, c) {
						return c.keyExists("decline_type") ? "Declined#( len(c.description) > 0 ? ": #c.description#" : "" )#" : c.text
					}, transaction.getProcessorResponseText());

					// if the CVV and/or AVS fails, the message should not be based on the response code, but the CVV/AVS code response
					avs_status = validateAVS(avsCodeStreet = transaction.getAvsStreetAddressResponseCode(), avsCodePostalCode = transaction.getAvsPostalCodeResponseCode(), rejectionReason = transaction.getGatewayRejectionReason());
					cvv_status = validateCVV(code = transaction.getCvvResponseCode(), rejectionReason = transaction.getGatewayRejectionReason());

					mapped_response_values = {
						message = result.isSuccess() ? "Approved" : avs_status.valid && cvv_status.valid ? response_code_message : avs_status.valid ? cvv_status.cvv_message : avs_status.avs_message,
						authorization_code = transaction.getProcessorAuthorizationCode(),
						response_code = transaction.getProcessorResponseCode(),
						response_text = transaction.getProcessorResponseText(),
						response_type = transaction.getProcessorResponseType(),
						settlement_response_code = transaction.getProcessorSettlementResponseCode(),
						settlement_response_text = transaction.getProcessorSettlementResponseText(),
						additional_response_text = transaction.getAdditionalProcessorResponse(),
						authorized_transaction_id = transaction.getAuthorizedTransactionId(),
						cvv_response_code = transaction.getCvvResponseCode(),
						avs_postalcode_response_code = transaction.getAvsPostalCodeResponseCode(),
						avs_streetaddress_response_code = transaction.getAvsStreetAddressResponseCode(),
						transaction_id = transaction.getId(),
						status = transaction.getStatus(),
						status_reason = transaction.getGatewayRejectionReason()
					}

					response.setStatus(result.isSuccess() ? getService().getStatusSuccessful() : getService().getStatusDeclined());
					response.setResult(result.isSuccess() ? mapped_response_values.status & ": " & mapped_response_values.response_text & ": " & mapped_response_values.response_code : mapped_response_values.status & ": (cvv code => #mapped_response_values.cvv_response_code#, avs street code => #mapped_response_values.avs_streetaddress_response_code#, avs postal code => #mapped_response_values.avs_postalcode_response_code#) " & mapped_response_values.response_code);
					response.setMessage(mapped_response_values.message);
					response.setTransactionID(mapped_response_values.transaction_id);
					response.setAuthorization(mapped_response_values.authorization_code);
					response.setAVSCode(mapped_response_values.avs_streetaddress_response_code);
					response.setCVVCode(mapped_response_values.cvv_response_code);

				} else if ( payload.type == "void" ) {
					transaction = gw.transaction().find(jstr(payload.transactionId));
					transaction_status = transaction.getStatus().name();

					if ( transaction_status == "AUTHORIZED" || transaction_status == "SUBMITTED_FOR_SETTLEMENT" || transaction_status == "SETTLEMENT_PENDING" ) {
						result = gw.transaction().voidTransaction(transaction.getId()); // sending to the Braintree gateway
						voided_transaction = result.getTransaction() === Null ? result.getTarget() : result.getTransaction();
					
						mapped_response_values = {
							message = result.isSuccess() ? "Transaction voided (original transaction: #transaction.getId()#)" : "Transaction (#transaction.getId()#) not voided",
							authorization_code = voided_transaction.getProcessorAuthorizationCode(),
							response_code = voided_transaction.getProcessorResponseCode(),
							response_text = voided_transaction.getProcessorResponseText(),
							response_type = voided_transaction.getProcessorResponseType(),
							settlement_response_code = voided_transaction.getProcessorSettlementResponseCode(),
							settlement_response_text = voided_transaction.getProcessorSettlementResponseText(),
							additional_response_text = voided_transaction.getAdditionalProcessorResponse(),
							authorized_transaction_id = voided_transaction.getAuthorizedTransactionId(),
							cvv_response_code = voided_transaction.getCvvResponseCode(),
							avs_postalcode_response_code = voided_transaction.getAvsPostalCodeResponseCode(),
							avs_streetaddress_response_code = voided_transaction.getAvsStreetAddressResponseCode(),
							transaction_id = voided_transaction.getId(),
							status = transaction.getStatus(),
							status_reason = transaction.getGatewayRejectionReason()
						};
	
						response.setStatus(result.isSuccess() ? getService().getStatusSuccessful() : getService().getStatusDeclined());	
	
						if ( result.isSuccess() ) {
							response.setParsedResult("");
							response.setMessage(mapped_response_values.message);
							response.setTransactionID(mapped_response_values.transaction_id);
							response.setAuthorization(mapped_response_values.authorization_code);
							response.setAVSCode(mapped_response_values.avs_streetaddress_response_code);
							response.setCVVCode(mapped_response_values.cvv_response_code);
						}
					} else {
						response.setStatus(getService().getStatusDeclined());
					}
				} else if ( payload.type == "refund" ) {
					transaction = gw.transaction().find(jstr(payload.transactionid));
					transaction_status = transaction.getStatus().name();

					if ( transaction_status == "SETTLED" || transaction_status == "SETTLING" ) {
						result = gw.transaction().refund(transaction.getId(), javacast("bigdecimal", payload.amount)); // sending to the Braintree gateway
						refunded_transaction = result.getTransaction() === Null ? result.getTarget() : result.getTransaction();
					
						mapped_response_values = {
							message = result.isSuccess() ? "Transaction (#transaction.getId()#) refunded" : "Transaction (#transaction.getId()#) not refunded",
							authorization_code = refunded_transaction.getProcessorAuthorizationCode(),
							response_code = refunded_transaction.getProcessorResponseCode(),
							response_text = refunded_transaction.getProcessorResponseText(),
							response_type = refunded_transaction.getProcessorResponseType(),
							settlement_response_code = refunded_transaction.getProcessorSettlementResponseCode(),
							settlement_response_text = refunded_transaction.getProcessorSettlementResponseText(),
							additional_response_text = refunded_transaction.getAdditionalProcessorResponse(),
							authorized_transaction_id = refunded_transaction.getAuthorizedTransactionId(),
							cvv_response_code = refunded_transaction.getCvvResponseCode(),
							avs_postalcode_response_code = refunded_transaction.getAvsPostalCodeResponseCode(),
							avs_streetaddress_response_code = refunded_transaction.getAvsStreetAddressResponseCode(),
							transaction_id = refunded_transaction.getId(),
							status = transaction.getStatus(),
							status_reason = transaction.getGatewayRejectionReason()
						};
	
						response.setStatus(result.isSuccess() ? getService().getStatusSuccessful() : getService().getStatusDeclined());	
	
						if ( result.isSuccess() ) {
							response.setResult(result.isSuccess() ? mapped_response_values.status & ": " & mapped_response_values.response_text & ": " & mapped_response_values.response_code : mapped_response_values.status & ": " & mapped_response_values.response_code);
							response.setMessage(mapped_response_values.message);
							response.setTransactionID(mapped_response_values.transaction_id);
							response.setAuthorization(mapped_response_values.authorization_code);
							response.setAVSCode(mapped_response_values.avs_streetaddress_response_code);
							response.setCVVCode(mapped_response_values.cvv_response_code);
						}
					} else {
						response.setStatus(getService().getStatusDeclined());	
					}
				} else {
					response.setStatus(getService().getStatusFailure());
				}
			} else {
				response.setStatus(getService().getStatusFailure());
			}
		} catch (Any e) {
			response.setStatus(getService().getStatusFailure());
			response.setMessage(serializejson(e));
		}

		return response;
	}

	public any function purchase(required any money, required any account, any transactionId, struct options = {}) {
		post = {
			amount = money.getAmount(),
			type = "sale"
		}

		account_type = lcase(listLast(getMetaData(account).fullname, "."));

		if ( account_type == "creditcard" ) {
			post = addCustomer(post = post, account = account);
			post = addCreditCard(post = post, account = account, options = options);
		} else if ( account_type == "token" ) {
			post = addToken(post = post, account = account, options = options);
		} else {
			throw type="cfpayment.InvalidAccount";
		}

		return process(payload = post, options = options);
	}

	public any function void(required any id, struct options = {}) {
		post = {
			type = "void",
			transactionId = id
		}

		return process(payload = post, options = options);
	}

	public any function credit(required any money, required any transactionId, struct options = {}) {
		post = {
			amount = money.getAmount(),
			type = "refund",
			transactionid = transactionId
		}

		return process(payload = post, options = options);
	}

	private any function addCustomer(required struct post, required any account) {
		post.firstname = account.getFirstName();
		post.lastname = account.getLastName();
		post.address = account.getAddress();
		post.locality = account.getCity();
		post.region = account.getRegion();
		post.postalcode = account.getPostalCode();
		post.country = account.getCountry();
		post.countryCode = account.getCountryCode();
		post.company = account.getCompany();
		post.email = account.getEmail();

		return post;
	}

	private any function addCreditCard(required struct post, required any account, struct options = {}) {
		post.payment = "creditcard";
		post.ccnumber = account.getAccount();
		post.ccexp = "#account.getMonth()#/#right(account.getYear(), 2)#";
		post.cvv = account.getVerificationValue();
		post.cardholderName = len(account.getNameOnCard()) > 0 ? account.getNameOnCard() : "#account.getFirstName()# #account.getLastName()#";

		if ( options.keyExists("tokenize") ) {
			post.customer_vault = "add_customer";
			
			if ( options.keyExists("tokenId") ) {
				post.customer_vault_id = options.tokenId;
			}
		}

		return post;
	}

	private any function addToken(required struct post, required any account) {
		post.customer_vault_id = account.getID();
		return post;
	}

	private struct function validateAVS(required string avsCodeStreet, required string avsCodePostalCode, boolean allowBlankCode = true, boolean allowPostalOnlyMatch = false, boolean allowStreetOnlyMatch = false, string rejectionReason = "") {
		result = {
			success = false,
			message = "",
			errors = [],
			valid = false,
			avs_message = "no avs passed"
		}	

		if ( len(rejectionReason) > 0 ) {
			// user account settings have overridden passed status in variables.avs_address_response_codes and variables.avs_postalcode_response_codes
			result.avs_message = "The street address and/or postal code provided do not match the information on file with the cardholder's bank.";
		} else {
			if ( allowBlankCode && ( len(avsCodeStreet) == 0 && len(avsCodePostalCode) == 0 ) ) {
				result.valid = true;
				result.avs_message = "AVS checks were skipped for this transaction.";
			} else {
				try {
					matching_street_codes = variables.avs_address_response_codes.filter(function(code) {
						return code.code == avsCodeStreet
					});
	
					matching_postal_codes = variables.avs_postalcode_response_codes.filter(function(code) {
						return code.code == avsCodePostalCode
					});
	
					if ( allowStreetOnlyMatch ) {
						if ( matching_street_codes.len() > 0 ) {
							match = matching_street_codes.first();
							result.valid = match.passes;
							result.avs_message = len(match.description) > 0 ? match.description : match.response;
						} else {
							result.errors.append("the AVS Street Code (#avsCodeStreet#) was not found");
						}
					} else if ( allowPostalOnlyMatch ) {
						if ( matching_postal_codes.len() > 0 ) {
							match = matching_postal_codes.first();
							result.valid = match.passes;
							result.avs_message = len(match.description) > 0 ? match.description : match.response;
						} else {
							result.errors.append("the AVS PostalCode Code (#avsCodePostalCode#) was not found");
						}
					} else {
						if ( matching_street_codes.len() > 0 && matching_postal_codes.len() > 0 ) {
							street_match = matching_street_codes.first();
							postalcode_match = matching_postal_codes.first();
							result.valid = street_match.passes && postalcode_match.passes;
							result.avs_message = street_match.passes ? postalcode_match.description : street_match.description;
						} else {
							result.errors.append("the AVS PostalCode Code (#avsCodePostalCode#) was not found");
						}
					}
				} catch (Any e) {
					result.errors.append(e.message);
				}
			}
		}

		result.success = result.errors.isEmpty();
		result.message = result.success ? "The AVS validation was successful." : "The AVS validation was not successful. See the error stack.";

		return result;
	}

	private struct function validateCVV(required string code, string rejectionReason = "") {
		result = {
			success = false,
			message = "",
			errors = [],
			valid = false,
			cvv_message = "no CVV value passed"
		}	

		if ( len(rejectionReason) > 0 ) {
			// user account settings have overridden passed status in variables.cvv_response_codes
			result.cvv_message = "The card security code provided does not match the information on file with the cardholder's bank.";
		} else {
			try {
				matching_cvv_codes = variables.cvv_response_codes.filter(function(cvv) {
					return cvv.code == code
				});

				if ( matching_cvv_codes.len() > 0 ) {
					match = matching_cvv_codes.first();
					result.valid = match.passes;
					result.cvv_message = len(match.description) > 0 ? match.description : match.response;
				} else {
					result.errors.append("the CVV code (#code#) was not found");
				}
			} catch (Any e) {
				result.errors.append(e.message);
			}
		}

		result.success = result.errors.isEmpty();
		result.message = result.success ? "The CVV validation was successful." : "The CVV validation was not successful. See the error stack.";

		return result;
	}

	private string function jstr(cfml_string) { 
		return javacast("java.lang.String", cfml_string);
	}
}
