module AddressesHelper
  def render_inline_address(address)
    "#{address.street_name} #{address.house_number}#{if address.address_addition.present?
                                                       ", #{address.address_addition}"
                                                     end}, #{address.postal_code} #{address.city}#{unless address.country.blank? || address.country.strip.downcase == 'deutschland'
                                                                                                     ", #{address.country}"
                                                                                                   end}"
  end

  def render_block_address(address)
    render 'addresses/address', address: address
  end
end
