report 70101 "Proforma Invoice 2"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts\Proforma_Invoice2.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {

            DataItemTableView = sorting("No.") order(ascending);
            column(No_; "No.") { }
            column(QuantityVar1; QuantityVar) { }
            column(AmountVar1; AmountVar) { }
            column(Posting_Date; "Posting Date") { }
            column(Order_Date; "Order Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(CompanyInfoPic; CompanyInfo.Picture) { }
            column(CompanyInfoBankName; CompanyInfo."Bank Name") { }
            column(CompanyInfoBankAcc; CompanyInfo."Bank Account No.") { }
            column(CompanyInfoBankBranchNo; CompanyInfo."Bank Branch No.") { }
            column(CompanyInfoVatReg; CompanyInfo."VAT Registration No.") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(CompanyAddr9; CompanyAddr[9]) { }
            column(CompanyAddr10; CompanyAddr[10]) { }
            column(BillToAddr1; BillToAddr[1]) { }
            column(BillToAddr2; BillToAddr[2]) { }
            column(BillToAddr3; BillToAddr[3]) { }
            column(BillToAddr4; BillToAddr[4]) { }
            column(BillToAddr5; BillToAddr[5]) { }
            column(BillToAddr6; BillToAddr[6]) { }
            column(BillToAddr7; BillToAddr[7]) { }
            column(BillToAddr8; BillToAddr[8]) { }
            column(BillToAddr9; BillToAddr[9]) { }
            column(BillToAddr10; BillToAddr[10]) { }
            column(GSTCaption; GSTCaption) { }
            column(ProformaCaption; ProformaCaption) { }
            column(BillTo_Caption; BillTo_Caption) { }
            column(PICaption; PICaption) { }
            column(SupplierCaption; SupplierCaption) { }
            column(DateCaption; DateCaption) { }
            column(BankCaption; BankCaption) { }
            column(RemarksCaption; RemarksCaption) { }
            column(ItemCaption; ItemCaption) { }
            column(QtyCaption; QtyCaption) { }
            column(AmountCaption; AmountCaption) { }
            column(FooterNoteCaption; FooterNoteCaption) { }
            column(UnitsCaption; UnitsCaption) { }
            column(ProdMonthCaption; ProdMonthCaption) { }
            column(DescriptionCaption; DescriptionCaption) { }
            column(HeadingCaption; HeadingCaption) { }
            column(SummaryCaption; SummaryCaption) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(SNo; SNo) { }
                column(Parent_item_Line_No_; "Parent item Line No.") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description) { }
                column(Description_2; "Description 2") { }
                column(VAT__; "VAT %") { }
                column(Quantity; Quantity) { }
                column(Unit_Price; "Unit Price") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Line_Amount; "Line Amount") { }
                column(GstVar; GstVar) { }
                column(QuantityVar; QuantityVar) { }
                column(Unit_Amount; Unit_Amount) { }
                column(TotalVar; TotalVar) { }
                column(AmountVar; AmountVar) { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    GLSetup.Get();
                    Clear(GstVar);
                    SL.Reset();
                    SL.SetFilter("VAT %", '<>%1', 0);
                    if SL.FindFirst() then
                        GstVar := SL."VAT %";

                    //Clear(DescriptionVar);
                    Clear(QuantityVar);
                    Clear(Unit_Amount);
                    Clear(AmountVar);
                    SL.Reset();
                    SL.SetRange("Document No.", SH."No.");
                    SL.SetRange("Document No.", "Sales Line"."Document No.");
                    if SL.FindSet() then begin
                        QuantityVar += 1;
                        SL.CalcSums(Quantity, "Amount Including VAT", "Unit Price", "Line Amount", "Line Discount Amount")
                    end;
                    Unit_Amount := SL."Unit Price";
                    AmountVar := SL."Amount Including VAT";
                    "LineAmount Var" := SL."Line Amount";
                    "LineDisc AmountVar" := SL."Line Discount Amount";
                    //"VAT %" := SL."VAT %";
                    SNo += 1;
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CompanyAddr);
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo.Address;
                CompanyAddr[3] := CompanyInfo."Address 2";
                CompanyAddr[4] := CompanyInfo.City;
                CompanyAddr[5] := CompanyInfo."Post Code";
                CompanyAddr[6] := CompanyInfo."Country/Region Code";
                CompanyAddr[7] := 'Tel No: ' + CompanyInfo."Phone No.";
                CompanyAddr[8] := 'Fax No: ' + CompanyInfo."Fax No.";
                CompanyAddr[9] := 'Email: ' + CompanyInfo."E-Mail";
                CompanyAddr[10] := 'GSTIN: ' + CompanyInfo."VAT Registration No.";
                CompressArray(CompanyAddr);
                Clear(BillToAddr);
                BillToAddr[1] := "Sales Header"."Bill-to Name";
                BillToAddr[2] := "Sales Header"."Bill-to Address";
                if "Bill-to Address 2" <> '' then
                    BillToAddr[3] := "Sales Header"."Bill-to Address 2";
                if "Sales Header"."Bill-to City" <> '' then
                    if BillToAddr[3] <> '' then
                        BillToAddr[3] := ',' + "Sales Header"."Bill-to City"
                    else
                        BillToAddr[3] := "Sales Header"."Bill-to City";
                BillToAddr[4] := "Sales Header"."Bill-to Post Code";
                BillToAddr[5] := "Sales Header"."Bill-to County";
                if "Sales Header"."Bill-to Country/Region Code" <> '' then
                    if CountryRegionCode.Get("Bill-to Country/Region Code") then begin
                        if BillToAddr[5] <> '' then
                            BillToAddr[5] += ' ' + CountryRegionCode.Name
                        else
                            BillToAddr[5] := CountryRegionCode.Name;
                    end;
                BillToAddr[6] := "Sales Header"."Bill-to Country/Region Code";
                BillToAddr[7] := 'Tel No: ' + "Sales Header"."Bill-to Contact No.";
                BillToAddr[8] := 'Fax No: ' + "Sales Header".GetSellToCustomerFaxNo();
                BillToAddr[9] := 'Email: ' + "Sales Header"."Sell-to E-Mail";
                BillToAddr[10] := 'GSTIN: ' + "Sales Header"."VAT Registration No.";
                CompressArray(BillToAddr);
                SNo := 0;
                QuantityVar := 0;
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin

    end;


    var
        myInt: Integer;
        CompanyInfo: Record "Company Information";
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        SL2: Record "Sales Line";
        SNo: Integer;
        GLSetup: Record "General Ledger Setup";
        exitline: Boolean;
        CompanyAddr: array[15] of Text;
        BillToAddr: array[15] of Text;
        CountryRegionCode: Record "Country/Region";
        GSTCaption: Label 'GST%';
        ProformaCaption: Label 'Proforma Invoice';
        BillTo_Caption: Label 'BILL TO :';
        PICaption: Label 'PI NO. :';
        SupplierCaption: Label 'SUPPLIER INVOICE NO. :';
        DateCaption: Label 'Date :';
        BankCaption: Label 'BANK NAME AND BANK ACCOUNT NO :';
        RemarksCaption: Label 'REMARKS';
        ItemCaption: Label 'ITEM';
        DescriptionCaption: Label 'DESCRIPTION OF GOODS';
        SummaryCaption: Label 'COMPANY ITEMS';
        QtyCaption: Label 'QUANTITY(Units)';
        UnitsCaption: Label 'UNITS(SGD)';
        AmountCaption: Label 'AMOUNTS(SGD)';
        ProdMonthCaption: Label 'Production Month';
        FooterNoteCaption: Label 'This is computer generated invoice';
        HeadingCaption: Label 'PROFORMA INVOICE';
        //DescriptionVar: Text[100];
        QuantityVar: Integer;
        Unit_Amount: Decimal;
        "LineAmount Var": Decimal;
        "LineDisc AmountVar": Decimal;
        AmountVar: Decimal;
        TotalVar: Decimal;
        //TotalVar2: Text;
        GstVar: Decimal;
}