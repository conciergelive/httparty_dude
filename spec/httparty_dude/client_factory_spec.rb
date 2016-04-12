require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe HTTPartyDude::ClientFactory do
  let(:pre_request_processor) { lambda { |client, method, path, options| options.merge!( query: { a: '1' } ) } }
  let(:response_processor) { lambda { |response| response } }
  let(:configuration) do
    {
      class_name: 'TicketEvolution',
      pre_request_processor: pre_request_processor, 
      response_processor: response_processor,
      base_uri: 'https://server.com/v9',
      methods: { 
        'ticket_groups_index' => {'/ticket_groups' => 'GET'},
        'ticket_group' => {'/ticket_groups/%{ticket_group_id}' => 'GET'}
      }
    }
  end

  describe '.create' do
    subject { described_class.create(configuration) }
    context "returns an object that" do

      it 'is the correct class type' do
        expect(subject.name).to eq('HTTPartyDude::Clients::TicketEvolution')
      end

      it 'has the correct base_uri' do
        expect(subject.base_uri).to eq(configuration[:base_uri])
      end 

      it 'responds to configured endpoint methods' do
        configuration[:methods].keys.each do |method_name|
          expect(subject.respond_to?(method_name)).to be_truthy
        end
      end  

      it 'can make a request via a configured endpoint method' do
       stub_http_response_with('ticket_groups.json')
       response = subject.ticket_groups_index
       expect(response.body).to eq(file_fixture('ticket_groups.json'))
      end

      it 'executes pre_request_processor when making a request' do
       stub_http_response_with('ticket_groups.json')
       expect(pre_request_processor).to receive(:call)
       subject.ticket_groups_index
      end

      it 'executes response_processor after making a request' do
       stub_http_response_with('ticket_groups.json')
       expect(response_processor).to receive(:call)
       subject.ticket_groups_index
      end                    
    end  
  end
end
