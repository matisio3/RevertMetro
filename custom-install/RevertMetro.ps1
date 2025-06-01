Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Kolory i czcionki
$mainColor = [System.Drawing.Color]::FromArgb(0x2d, 0x2d, 0x30)
$accentColor = [System.Drawing.Color]::FromArgb(0x00, 0x99, 0xcc)
$buttonColor = [System.Drawing.Color]::FromArgb(0x1e, 0x90, 0xff)
$buttonHoverColor = [System.Drawing.Color]::FromArgb(0x00, 0x7a, 0xcc)
$font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$titleFont = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)

# Główna forma
$form = New-Object System.Windows.Forms.Form
$form.Text = "RevertMetro Installer"
$form.Size = New-Object System.Drawing.Size(440, 400)
$form.StartPosition = "CenterScreen"
$form.BackColor = $mainColor
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $true
$form.Font = $font

# Logo
$tempLogo = "$env:TEMP\revertmetro_logo.png"
$logoUrl = "https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/logo2.png"
try {
    Invoke-WebRequest -Uri $logoUrl -OutFile $tempLogo -ErrorAction Stop
} catch {}
if (Test-Path $tempLogo) {
    $pictureBox = New-Object System.Windows.Forms.PictureBox
    $pictureBox.Image = [System.Drawing.Image]::FromFile($tempLogo)
    $pictureBox.SizeMode = "Zoom"
    $pictureBox.Size = New-Object System.Drawing.Size(180, 80)
    $pictureBox.Location = New-Object System.Drawing.Point(130, 20)
    $pictureBox.BackColor = "Transparent"
    $form.Controls.Add($pictureBox)
}

# Tytuł
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "RevertMetro Installer"
$titleLabel.Font = $titleFont
$titleLabel.ForeColor = $accentColor
$titleLabel.BackColor = "Transparent"
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(90, 110)
$form.Controls.Add($titleLabel)

# Opis
$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Text = "Wybierz sposób instalacji RevertMetro lub przeczytaj dokumentację."
$descLabel.ForeColor = "White"
$descLabel.BackColor = "Transparent"
$descLabel.AutoSize = $true
$descLabel.Location = New-Object System.Drawing.Point(40, 150)
$form.Controls.Add($descLabel)

# Funkcja stylowania przycisków
function Set-ButtonStyle($btn) {
    $btn.FlatStyle = "Flat"
    $btn.BackColor = $buttonColor
    $btn.ForeColor = "White"
    $btn.Font = $font
    $btn.FlatAppearance.BorderSize = 0
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Add_MouseEnter({ param($s, $e) $this.BackColor = $buttonHoverColor })
    $btn.Add_MouseLeave({ param($s, $e) $this.BackColor = $buttonColor })
}

# Przycisk "Przejdź dalej"
$nextButton = New-Object System.Windows.Forms.Button
$nextButton.Text = "Przejdź dalej"
$nextButton.Size = New-Object System.Drawing.Size(150, 45)
$nextButton.Location = New-Object System.Drawing.Point(40, 210)
Set-ButtonStyle $nextButton
$nextButton.Add_Click({
    # Okno wyboru typu instalacji
    $installTypeForm = New-Object System.Windows.Forms.Form
    $installTypeForm.Text = "Wybierz typ instalacji"
    $installTypeForm.Size = New-Object System.Drawing.Size(370, 200)
    $installTypeForm.StartPosition = "CenterParent"
    $installTypeForm.FormBorderStyle = 'FixedDialog'
    $installTypeForm.MaximizeBox = $false
    $installTypeForm.MinimizeBox = $true
    $installTypeForm.BackColor = $mainColor
    $installTypeForm.Font = $font

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Wybierz tryb instalacji:"
    $label.ForeColor = "White"
    $label.BackColor = "Transparent"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(30, 20)
    $installTypeForm.Controls.Add($label)

    $expressButton = New-Object System.Windows.Forms.Button
    $expressButton.Text = "Instalacja ekspresowa"
    $expressButton.Size = New-Object System.Drawing.Size(140, 40)
    $expressButton.Location = New-Object System.Drawing.Point(30, 60)
    Set-ButtonStyle $expressButton
    $expressButton.Add_Click({
        $installTypeForm.Close()
        try {
            $tempDir = "$env:TEMP\RevertMetroInstall"
            if (-not (Test-Path $tempDir)) {
                New-Item -ItemType Directory -Path $tempDir | Out-Null
            }
            $mainExe = "$tempDir\main.exe"
            $installWindowExe = "$tempDir\install_window.exe"
            Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/main.exe" -OutFile $mainExe -ErrorAction Stop
            Invoke-WebRequest -Uri "https://github.com/matisio3/RevertMetro/raw/refs/heads/main/install_window.exe" -OutFile $installWindowExe -ErrorAction Stop
            Start-Process -FilePath $mainExe -WindowStyle Minimized
            Start-Process -FilePath $installWindowExe
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Wystąpił błąd podczas instalacji: $_", "Błąd")
        }
    })
    $installTypeForm.Controls.Add($expressButton)

    $customButton = New-Object System.Windows.Forms.Button
    $customButton.Text = "Instalacja customowa"
    $customButton.Size = New-Object System.Drawing.Size(140, 40)
    $customButton.Location = New-Object System.Drawing.Point(190, 60)
    Set-ButtonStyle $customButton
    $customButton.Add_Click({
        $installTypeForm.Close()
        # Okno wyboru komponentów
        $customForm = New-Object System.Windows.Forms.Form
        $customForm.Text = "Wybierz komponenty"
        $customForm.Size = New-Object System.Drawing.Size(400, 300)
        $customForm.StartPosition = "CenterParent"
        $customForm.FormBorderStyle = 'FixedDialog'
        $customForm.MaximizeBox = $false
        $customForm.MinimizeBox = $true
        $customForm.BackColor = $mainColor
        $customForm.Font = $font

        $label2 = New-Object System.Windows.Forms.Label
        $label2.Text = "Zaznacz komponenty do instalacji:"
        $label2.ForeColor = "White"
        $label2.BackColor = "Transparent"
        $label2.AutoSize = $true
        $label2.Location = New-Object System.Drawing.Point(30, 20)
        $customForm.Controls.Add($label2)

        $taskbarCheck = New-Object System.Windows.Forms.CheckBox
        $taskbarCheck.Text = "Taskbar"
        $taskbarCheck.ForeColor = "White"
        $taskbarCheck.BackColor = "Transparent"
        $taskbarCheck.Location = New-Object System.Drawing.Point(30, 60)
        $customForm.Controls.Add($taskbarCheck)

        $startMenuCheck = New-Object System.Windows.Forms.CheckBox
        $startMenuCheck.Text = "Menu Start"
        $startMenuCheck.ForeColor = "White"
        $startMenuCheck.BackColor = "Transparent"
        $startMenuCheck.Location = New-Object System.Drawing.Point(30, 90)
        $customForm.Controls.Add($startMenuCheck)

        $explorerCheck = New-Object System.Windows.Forms.CheckBox
        $explorerCheck.Text = "Explorer"
        $explorerCheck.ForeColor = "White"
        $explorerCheck.BackColor = "Transparent"
        $explorerCheck.Location = New-Object System.Drawing.Point(30, 120)
        $customForm.Controls.Add($explorerCheck)

        $queue = @()

        $installCustomButton = New-Object System.Windows.Forms.Button
        $installCustomButton.Text = "Zainstaluj wybrane"
        $installCustomButton.Size = New-Object System.Drawing.Size(160, 45)
        $installCustomButton.Location = New-Object System.Drawing.Point(120, 200)
        Set-ButtonStyle $installCustomButton
        $installCustomButton.Add_Click({
            if ($taskbarCheck.Checked) { $queue += "Taskbar" }
            if ($startMenuCheck.Checked) { $queue += "Menu Start" }
            if ($explorerCheck.Checked) { $queue += "Explorer" }
            $customForm.Close()
            if ($queue.Count -eq 0) {
                [System.Windows.Forms.MessageBox]::Show("Nie wybrano żadnych komponentów.", "Informacja")
            } else {
                $msg = "Dodano do instalacji:`n" + ($queue -join "`n")
                [System.Windows.Forms.MessageBox]::Show($msg, "Kolejka instalacji")
                # Tutaj dodaj kod instalacji dla każdego komponentu
            }
        })
        $customForm.Controls.Add($installCustomButton)
        $customForm.ShowDialog()
    })
    $installTypeForm.Controls.Add($customButton)

    $installTypeForm.ShowDialog()
})
$form.Controls.Add($nextButton)

# Przycisk README
$readmeButton = New-Object System.Windows.Forms.Button
$readmeButton.Text = "README"
$readmeButton.Size = New-Object System.Drawing.Size(150, 45)
$readmeButton.Location = New-Object System.Drawing.Point(230, 210)
Set-ButtonStyle $readmeButton
$readmeButton.Add_Click({
    Start-Process "https://raw.githubusercontent.com/matisio3/RevertMetro/refs/heads/main/readme.pdf"
})
$form.Controls.Add($readmeButton)

# Etykieta wersji w prawym dolnym rogu
$label = New-Object System.Windows.Forms.Label
$label.Text = "v1.1"
$label.AutoSize = $true
$label.ForeColor = "Gray"
$label.BackColor = "Transparent"
$label.Location = New-Object System.Drawing.Point(($form.ClientSize.Width - 50), ($form.ClientSize.Height - 30))
$label.Anchor = "Bottom, Right"
$form.Controls.Add($label)

# Wyświetlenie GUI
[void]$form.ShowDialog()