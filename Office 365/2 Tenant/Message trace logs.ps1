##Get message trace logs for the X days
$SenderAddress = "user@domain.com"
$RecipientAddress = "user@domain.com"
$StartDate = (Get-Date -Hour 00 -Minute 00 -Second 00).AddDays(-90)
$EndDate = (Get-Date -Hour 00 -Minute 00 -Second 00)

$messageTrace = @()
$page = 1
$pageSize = 5000

do
{
	Write-Progress -Activity 'Collecting all messages' -CurrentOperation $page
	$messagesThisPage = Get-MessageTrace -SenderAddress $SenderAddress -RecipientAddress $RecipientAddress -StartDate $StartDate -EndDate $EndDate -PageSize $pageSize -Page $page
	$messageTrace += $messagesThisPage
	$page++
}
until ($messagesThisPage.count -eq 0)

$messageTrace | Where-Object {$_.MessageId -notlike "*prod.outlook.com>"} | export-csv "C:\temp\MessageTrace $(Get-date -Format 'yyyy-MM-dd').csv"
