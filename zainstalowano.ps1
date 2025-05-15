Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Tworzenie formularza
$form = New-Object System.Windows.Forms.Form
$form.Text = "Instalator"
$form.Size = New-Object System.Drawing.Size(400,150)
$form.StartPosition = "CenterScreen"
$form.BackColor = "Black"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Tworzenie paska postępu
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(50,30)
$progressBar.Size = New-Object System.Drawing.Size(300,30)
$progressBar.Style = 'Continuous'
$progressBar.Value = 100
$form.Controls.Add($progressBar)

# Tworzenie etykiety z tekstem
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(50,70)
$label.Size = New-Object System.Drawing.Size(300,20)
$label.Text = "Instalacja zako�czona"
$label.ForeColor = "White"
$label.TextAlign = "MiddleCenter"
$label.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$label.BackColor = "Black"
$form.Controls.Add($label)

# Wyświetlenie formularza
$form.ShowDialog()
