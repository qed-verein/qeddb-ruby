module AddressesHelper
  def render_inline_address(address)
    "#{address.street_name} #{address.house_number}#{address.address_addition.blank? ? '' : ", #{address.address_addition}"}, #{address.postal_code} #{address.city}#{address.country.blank? || address.country.strip.downcase == 'deutschland' ? '' : ", #{address.country}"}"
  end

  def render_block_address(address)
    render 'addresses/address', address: address
  end
end
