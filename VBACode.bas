Sub StockSummary()

'--Define variables
Dim Ticker As String
Dim OpenPrice As Double
Dim ClosePrice As Double
Dim Volume As Double
Dim TotalVolumeRow As Integer
Dim PercentChange As Double
Dim AnnualChange As Double
Dim PerInc As Double
Dim PerDec As Double
Dim TotVol As Double
Dim ActTick As String
Dim ws As Worksheet

'--Make sure to save file as XLSM

'--Create columns to report results
For Each ws In ThisWorkbook.Worksheets
ws.Range("i1").Value = "Ticker"
ws.Range("j1").Value = "Yearly Change"
ws.Range("k1").Value = "Percent change"
ws.Range("l1").Value = "Total Stock Volume"
ws.Range("n2").Value = "Greatest % Inc"
ws.Range("n3").Value = "Greatest % Dec"
ws.Range("n4").Value = "Greatest Total Volume"
ws.Range("o1").Value = "Ticker"
ws.Range("p1").Value = "Value"

Next

'--Run calculations for every sheet

For Each ws In ThisWorkbook.Worksheets

LastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
OpenPrice = ws.Range("c3")
Volume = 0
TotalVolumeRow = 2

    For d = 2 To LastRow
'--Check to see if tickers match
    If ws.Cells(d + 1, 1).Value <> ws.Cells(d, 1).Value Then
'--If they don't match, assign current ticker as "active" ticker and print in the summary table
        Ticker = ws.Cells(d, 1).Value
        ws.Range("I" & TotalVolumeRow).Value = Ticker
'--Total all previous volume accumulations for active ticker and print in the summary table
        Volume = Volume + ws.Cells(d, 7).Value
        ws.Range("L" & TotalVolumeRow).Value = Volume
'--Assign Closing date to current ticker
        ClosePrice = ws.Cells(d, 6).Value
'--Find difference between close price and open price and print in the summary table
        AnnualChange = ClosePrice - OpenPrice
        If OpenPrice = 0 Then
            PercentChange = 0
            Else
            PercentChange = AnnualChange / OpenPrice
        End If
        ws.Range("j" & TotalVolumeRow).Value = AnnualChange
        ws.Range("k" & TotalVolumeRow).Value = PercentChange
'--Reset the Open price
        OpenPrice = ws.Cells(d + 1, 3)
'--New summary table line assigned for next ticker and reset volume accumulator
        TotalVolumeRow = TotalVolumeRow + 1
        Volume = 0
'--If tickers DO match, then accumulate additional volume
    Else
        Volume = Volume + ws.Cells(d, 7).Value
    End If
    Next d
    
'--Convert Percentage numbers to % format
    For p = 2 To LastRow
    ws.Range("K" & p).NumberFormat = "0.00%"
    Next p
    
'--Find Greatest % Increase, Decrease & Total Volume
    
    PerInc = 0
    PerDec = 0
    TotVol = 0
    
    For i = 2 To LastRow
'--If the active %inc is > current %inc, then it becomes new Current inc%
        If ws.Cells(i, 11) > PerInc Then
            PerInc = ws.Cells(i, 11).Value
            ActTick = ws.Cells(i, 9).Value
        End If
    Next i
'--Report results
    ws.Range("o2") = ActTick
    ws.Range("p2") = PerInc
        
    For d = 2 To LastRow
'--If the active %dec is < current %dec, then it becomes new Current dec%
        If ws.Cells(d, 11) < PerDec Then
            PerDec = ws.Cells(d, 11).Value
            ActTick = ws.Cells(d, 9).Value
        End If
    Next d
'--Report results
    ws.Range("o3") = ActTick
    ws.Range("p3") = PerDec
    
    For v = 2 To LastRow
'--If the active Total Volume is > Current total volume, then it becomes new Current Total Volume
        If ws.Cells(v, 12) > TotVol Then
            TotVol = ws.Cells(v, 12).Value
            ActTick = ws.Cells(v, 9).Value
        End If
    Next v
'--Report results
    ws.Range("o4") = ActTick
    ws.Range("p4") = TotVol
    
'--Convert Percentage numbers to % format
    For p = 2 To 3
    ws.Range("p" & p).NumberFormat = "0.00%"
    Next p
    
'--Conditionally Format cells
    For A = 2 To LastRow
    If ws.Range("K" & A) > 0 Then
        ws.Range("K" & A).Interior.ColorIndex = 4
    ElseIf ws.Range("K" & A) < 0 Then
        ws.Range("K" & A).Interior.ColorIndex = 3
    End If
    Next A

'--Resize columns
ws.Columns("A:P").AutoFit
    
Next

End Sub

