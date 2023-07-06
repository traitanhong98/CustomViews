//
//  ViewController.swift
//  WebviewTest
//
//  Created by ECO0542-HoangNM on 05/08/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string1 = """
<h2>
    <ol>
        <li>I have carefully read each section of, and the supplements to, the Options Clearing Corporation("OCC") document "Characteristics and Risks of Standardized Options" (the "OCC Risk Disclosure Document");
        I have carefully read each section of, and the supplements to, the Options Clearing Corporation("OCC") document "Characteristics and Risks of Standardized Options" (the "OCC Risk Disclosure Document")</li>
        <li>I have received and carefully read the "Special Statement for uncovered Option Writers" (set forth below);</li>
        <li>I have carefully read the "Disclosure Regarding the Procedures for Allocating Equity option Exercise Notices Assigned by OCC" (Exercise Allocation Disclosure);</li>
        <li>I understand the contents of the OCC Risk Disclosure Statement, the Special Statement for Uncovered Option Writers and the Exercise Allocation Disclosure, each of which is in a language I fully understand; and</li>
        <li>If there is any aspect of the OCC Risk Disclosure Statement, the Special Statement for Uncovered Option Writers and Exercise Allocation Disclosure</li>
    </ol>
</h2>
</body>
"""
        let string2 = """
<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>
<h1>
Dear Valued Customer,</br></br>To trade foreign shares or overseas-listed investment products, you need to acknowledge the Risk Warning Statement (RWS) first before you can place orders.</br></br>OVERSEAS-LISTED INVESTMENT PRODUCTS</br>RISK WARNING</br></br>An overseas-listed investment products* is subject to the laws and regulations of the jurisdiction it is listed in. Before you trade in an overseas-listed investment product or authorise someone else to trade for you, you should be aware of:</br></br>The level of investor protection and safeguards that you are afforded in the relevant foreign jurisdiction as the overseas-listed investment product would operate under a different regulatory regime.</br>The differences between the legal systems in the foreign jurisdiction and Singapore that may affect your ability to recover your funds.</br>The tax implications, currency risks and additional transaction costs that you may have to incur.</br>The counterparty and correspondent broker risks that you are exposed to.</br>The political, economic and social developments that influence the overseas markets you are investing in.</br>These and other risks may affect the value of your investment. You should not invest in the product if you do not understand or are not comfortable with such risks.  </br></br>*An \"overseas-listed investment product\" in this statement refers to a capital markets products that is approved in-principle for listing and quotation on, or listed for quotation or quoted only on, one or more overseas exchange(s).</br></br>    1. This statement is provided to you in accordance with paragraph 29D of the Notice on the Sale of Investment Products [SFA04-N12 (Amendment No.2) 2018].</br></br>    2. This statement does not disclose all the risks and other significant aspects of trading in an overseas-listed investment products. You should undertake such transactions only if you understand and are comfortable with the extent of your exposure to the risk.</br></br>    3. You should carefully consider whether such trading is suitable for you in light of your experience, objectives, risk appetite, financial resources and other relevant circumstances. In considering whether to trade or to authorise someone else to trade for you, you should be aware of the following:</br>Differences in Regulatory Regimes</br></br>    a. Overseas markets may be subject to different regulations, and may operate differently from approved exchanges in Singapore. For example, there may be different rules providing for the safekeeping of securities and monies held by custodian banks or depositories. This may affect the level of safeguards in place to ensure proper segregation and safekeeping of your investment products or monies held overseas. There is also the risk of your investment products or monies not being protected if the custodian has credit problems or fails. Overseas markets may also have different periods for clearing and settling transactions. These may affect the information available to you regarding transaction prices and the time you have to settle your trade on such overseas markets.</br></br>    b. Overseas markets may be subject to rules which may offer different investor protection as compared to Singapore. Before you start to trade, you should be fully aware of the types of redress available to you in Singapore and other relevant jurisdiction, if any.</br>    c. Overseas-listed investment products may not be subject to the same disclose standards that apply to investment products listed for quotation or quoted on an approved exchange in Singapore. Where disclosure is made, differences in accounting, auditing and financial reporting standards may also affect the quality and comparability of information provided. It may also be more difficult to locate up-to-date information, and the information published may only be available in a foreign language.</br></br>Differences in legal systems</br></br>    d. In some countries, legal concepts which are practiced in mature legal systems may not be in place or may have yet to be tested in courts. This would make it more difficult to predict with a degree of certainty the outcome of judicial proceeding or even the quantum of damages which may be awarded following a successful claim.</br>    e. The Monetary Authority of Singapore will be unable to compel the enforcement of the rules of the regulatory authorities or markets in other jurisdiction where your transactions will be effected.</br>    f. The laws of some jurisdictions may prohibit or restrict the repatriation of funds from such jurisdictions including capital, divestment proceeds, profits, dividends and interest arising from investment in such countries. Therefore, there is no guarantee that the funds you have invested and the funds arising from your investment will be capable of being remitted.</br>    g. Some jurisdictions may also restricts the amount or type of investment products that foreign investors may trade. This can affect the liquidity and prices of the overseas-listed investment products that you invest in.</br></br>Differences costs involved</br></br>    h. There may be tax implications and investing in an overseas-listed investment product. For example, sales proceeds or the receipt of any dividends and other income may be subject to tax levies, duties or charges in the foreign country, in Singapore, or in both countries.</br>    i. Your investment return on foreign currency-denominated investment products will be affected by exchange rate fluctuations where there is a need to convert from currency of denomination of the investment products to another currency, or may be affected by exchanges controls.</br><span style = "padding-left: 20;"></span>j. You may have to pay additional costs such as fees and broker 2019s commissions for transactions in overseas exchanges. In some jurisdictions, you may also have to pay a premium to trade certain listed investment products. Therefore, before you before you begin to trade, you should obtain a clear explanation of all commissions, fees and other charges for which you will be liable. These charges will affect your net profit (if any) or increase your loss.</br></br>Counterparty and correspondent broker risks</br></br>    &nbsp;k. Transactions on overseas exchanges or overseas markets are generally effected by your Singapore brokers through the use of foreign brokers who have trading and/or clearing rights on those exchanges. All transactions that are executed upon your instructions with such counterparties and correspondent brokers are dependent on their respective due performance of their obligations. The insolvency or default of such counterparties and correspondent brokers may lead to positions being liquidated or closed out without your consent and/or may result in difficulties in recovering your monies and assets held overseas.</br></br>Political, Economic and Social Developments</br></br>    l. Overseas markets are influenced by the political, economic and social developments in the foreign jurisdiction, which may be uncertain and may increase the risk of investing in the overseas-listed investment products.</br></br>I acknowledge that I have read the Risk Warning Statement, understand its contents, and accept the risks involved</br></br>This assessment is only the English version. If you need other language assistance, please contact your representative. Thank you.
</h1>
"""
        let string3 = """
        <head>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
        </head>
        <body>
        <h1>ABCDEF abcdef 1234567</h1>
        </body>
        """
        webview.loadHTMLString(string3, baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "SO-Form", ofType: ".css") ?? ""))
        webview.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.changeDarkTheme(bgColor: "#0B0F1B")
    }
}
extension WKWebView {
    func changeDarkTheme(bgColor: String) {
        self.evaluateJavaScript("""
        document.body.style.backgroundColor = '#0F1527';
        document.body.style.color = '#D3D3D3';
        document.body.style.fontFamily = 'Helvetica';
        document.body.style.fontSize = '14px';
""", completionHandler: nil)
    }
}
