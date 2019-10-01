<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
	<RequestData>
		<Vendor></Vendor>
		<Partner></Partner>
		<Transactions>
			<Transaction>
				<Sale>
					<PayData>
						<Invoice>
							<BillTo>
								<Address>
									<Street></Street>
									<City></City>
									<State></State>
									<Zip></Zip>
									<Country></Country>
								</Address>
								<EMail></EMail>
							</BillTo>
							<TotalAmt></TotalAmt>
							<Description></Description>
							<Comment></Comment>
						</Invoice>
						<Tender>
							<Card>
								<CardType></CardType>
								<CardNum></CardNum>
								<ExpDate></ExpDate>
								<CVNum></CVNum>
								<NameOnCard></NameOnCard>
							</Card>
						</Tender>
					</PayData>
				</Sale>
			</Transaction>
		</Transactions>
	</RequestData>
	<RequestAuth>
		<UserPass>
			<User></User>
			<Password></Password>
		</UserPass>
	</RequestAuth>
</XMLPayRequest>



<!--// 
		https://www.paypalobjects.com/webstatic/en_US/developer/docs/pdf/pp_payflowpro_xmlpay_guide.pdf (page 133)

		<!ELEMENT TotalAmt (#PCDATA)>
		<!ATTLIST TotalAmt Currency CDATA #IMPLIED>

		<TotalAmt Currency="978">1.23</TotalAmt>


		TABLE G.4 FDMS South currency codes
		Currency Name					Currency Code		Decimal Positions
		Argentine Peso 					32 					2
		Australian Dollar 				36 					2
		Austrian Schilling 				40 					2
		Belgian Franc 					56 					0
		Canadian Dollar 				124 				2
		Chilean Peso 					152 				2
		Czech Koruna 					203 				2
		Danish Krone 					208 				2
		Dominican Peso 					214 				2
		Markka 							246 				2
		French Franc 					250 				2
		Deutsche Mark 					280 				2
		Drachma 						300 				0
		Hong Kong Dollar 				344 				2
		Indian Rupee 					356 				2
		Irish Punt 						372 				2
		Shekel 							376 				2
		Italian Lira 					380 				0
		Yen 							392 				0
		Won 							410 				0
		Luxembourg Franc 				442 				0
		Mexican Duevo Peso 				484 				2
		Netherlands Guilder 			528 				2
		New Zealand Dollar 				554 				2
		Norwegian Frone 				578 				2
		Philippine Peso 				608 				2
		Portuguese Escudo 				620 				0
		Rand 							710 				2
		Spanish Peseta 					724 				0
		Swedish Krona 					752 				2
		Swiss Franc 					756 				2
		Thailand Baht 					764 				2
		Pound Sterling 					826 				2
		Russian Ruble 					810 				2
		U.S Dollar 						840 				2
		Bolivar 						862 				2
		New Taiwan Dollar 				901 				2
		Euro 							978 				2
		Polish New Zloty 				985 				2
		Brazilian Real 					986 				2


		Maybe pass it as an extended field?  But that is the recurring payment payload.

		<Tender>
			<Card>
				<CardNum>5105105105105100</CardNum>
				<ExpDate>200803</ExpDate>
				<NameOnCard>name</NameOnCard>
			</Card>
		</Tender>
		<RPData>
			<Name>Test Profile</Name>
			<ExtData Name="CURRENCY" Value="EUR"></ExtData>
			<TotalAmt>1.23</TotalAmt>
//-->