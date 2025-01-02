require 'gtk4'
require 'shellwords'

class GoblinApp
  def initialize
    @app = Gtk::Application.new("com.example.Goblin", :flags_none)

    @app.signal_connect("activate") do |application|
      create_window(application)
    end
  end

  def create_window(application)
    # Erstelle ein Fenster
    window = Gtk::ApplicationWindow.new(application)
    window.set_title("Goblin")
    window.set_default_size(400, 300)

    # Erstelle ein vertikales Box-Layout
    vbox = Gtk::Box.new(:vertical, 10)
    vbox.margin_top = 20
    vbox.margin_bottom = 20
    vbox.margin_start = 20
    vbox.margin_end = 20

    # Buttons zum Auswählen von Dateien
    source_button = Gtk::Button.new(label: "Select Source File (PDF)")
    output_button = Gtk::Button.new(label: "Select Output File (ODF)")

    # Labels zur Anzeige der ausgewählten Dateipfade
    @source_label = Gtk::Label.new("No file selected")
    @output_label = Gtk::Label.new("No file selected")

    source_button.signal_connect("clicked") do
      file = open_file_dialog(window, "Select PDF Source File", Gtk::FileChooserAction::OPEN)
      @source_label.text = file if file
    end

    output_button.signal_connect("clicked") do
      file = open_file_dialog(window, "Select Output ODF File", Gtk::FileChooserAction::SAVE)
      @output_label.text = file if file
    end

    # Dropdown für Graustufen und Monochrom
    dropdown = Gtk::ComboBoxText.new
    dropdown.append_text("Grayscale")
    dropdown.append_text("Monochrome")
    dropdown.active = 0
    vbox.append(Gtk::Label.new("Conversion Mode:"))
    vbox.append(dropdown)

    # Numerisches Textfeld für die Dichte
    density_entry = Gtk::Entry.new
    density_entry.text = "300"
    vbox.append(Gtk::Label.new("Density (default 300):"))
    vbox.append(density_entry)

    # Füge Quell- und Ausgabedateiauswähler zur Benutzeroberfläche hinzu
    vbox.append(Gtk::Label.new("Source File:"))
    vbox.append(@source_label)
    vbox.append(source_button)

    vbox.append(Gtk::Label.new("Output File:"))
    vbox.append(@output_label)
    vbox.append(output_button)

    # Konvertierungsbutton
    convert_button = Gtk::Button.new(label: "Convert")
    vbox.append(convert_button)

    # Verbinde den Konvertierungsbutton mit der Befehlsausführung
    convert_button.signal_connect("clicked") do
      source_file = @source_label.text
      output_file = @output_label.text
      mode = dropdown.active_text.downcase
      density = density_entry.text.to_i

      if source_file != "No file selected" && output_file != "No file selected"
        command = "convert -density #{density} -#{mode} #{Shellwords.escape(source_file)} #{Shellwords.escape(output_file)}"
        system(command)
        Gtk::MessageDialog.new(parent: window, message_type: :info, buttons: :ok, text: "Conversion Complete!").run
      else
        Gtk::MessageDialog.new(parent: window, message_type: :error, buttons: :ok, text: "Please select both source and output files.").run
      end
    end

    # Füge das Layout zum Fenster hinzu
    window.child = vbox

    # Zeige das Fenster an
    window.present
  end

  def open_file_dialog(parent, title, action)
    dialog = Gtk::FileChooserDialog.new(title: title, parent: parent, action: action)
    dialog.add_button("_Cancel", Gtk::ResponseType::CANCEL)
    dialog.add_button("_Open", Gtk::ResponseType::ACCEPT) if action == Gtk::FileChooserAction::OPEN
    dialog.add_button("_Save", Gtk::ResponseType::ACCEPT) if action == Gtk::FileChooserAction::SAVE

    file_path = nil
    if dialog.run == Gtk::ResponseType::ACCEPT
      file_path = dialog.filename
    end
    dialog.destroy
    file_path
  end

  def run
    @app.run
  end
end

GoblinApp.new.run