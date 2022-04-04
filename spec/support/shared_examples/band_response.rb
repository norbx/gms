# frozen_string_literal: true

RSpec.shared_examples 'Band response' do
  it 'returns proper json attributes' do
    subject

    band.reload

    expect(json_response[:band]).to be_a(Hash)
    expect(json_response[:band][:id]).to be_present
    expect(json_response[:band][:name]).to be_present
    expect(json_response[:band][:contact_name]).to be_present
    expect(json_response[:band][:phone_number]).to be_present
    expect(json_response[:band][:description]).to be_present
    expect(json_response[:band][:social_links]).to be_present
    expect(json_response[:band][:images]).to be_an(Array)
    expect(json_response[:band][:images][0][:id]).to be_present
    expect(json_response[:band][:images][0][:url]).to be_present
    expect(json_response[:band][:tags]).to be_an(Array)
    expect(json_response[:band][:tags][0][:id]).to be_present
    expect(json_response[:band][:tags][0][:name]).to be_present
  end
end
