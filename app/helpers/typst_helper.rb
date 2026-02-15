module TypstHelper
  def render_typst_template template, inputs
    root = Rails.root.join('app', 'templates')
    file = root.join(template)
    sys_inputs = common_inputs.merge(inputs)

    pdf = Typst::Pdf.new file: file, root: root, sys_inputs: sys_inputs
    pdf.compiled.bytes[0].pack('c*')
  end

  private

  def common_inputs() = {
    'footer.adresse': "#{Rails.configuration.qed_name}\np.Adr. #{Rails.configuration.qed_address}",
    'footer.internet': "#{Rails.configuration.qed_homepage}",
    'footer.vorstand': "#{Rails.configuration.qed_vorstand}",
    'footer.bankverbindung': "#{Rails.configuration.banking_name}\n#{Rails.configuration.iban}\n#{Rails.configuration.bic}"
  }
end
