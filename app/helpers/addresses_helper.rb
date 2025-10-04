module AddressesHelper
  def render_inline_address(address)
    format(
      '%<street>s %<house_number>s%<address_addition>s, %<postal_code>s %<city>s%<country>s',
      street: address.street_name,
      house_number: address.house_number,
      address_addition: address.address_addition.blank? ? '' : ", #{address.address_addition}",
      postal_code: address.postal_code,
      city: address.city,
      country: address.country.blank? || address.country.strip.downcase == 'deutschland' ? '' : ", #{address.country}"
    )
  end

  def render_block_address(address)
    render 'addresses/address', address: address
  end
end
