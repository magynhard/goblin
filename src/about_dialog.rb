class AboutDialog
  def self.show(parent)
    dialog = Adwaita::AboutDialog.new
    dialog.application_name = "Goblin Doc"
    dialog.developer_name = %Q(#{_("A simple document converter")}\n\n#{RUBY_ENGINE} #{RUBY_VERSION}@#{RUBY_PLATFORM}])
    dialog.application_icon = "de.magynhard.GoblinDoc"
    dialog.website = "https://github.com/magynhard/goblin-doc?tab=readme-ov-file#readme"
    dialog.issue_url = "https://github.com/magynhard/goblin-doc/issues"
    dialog.version = "0.2.1"
    dialog.developers = ["Matthäus J. N. Beyrle <goblin-doc.github.com@mail.magynhard.de>"]
    dialog.license_type = Gtk::License::MIT_X11
    dialog.show
    dialog.present(parent)
  end
end