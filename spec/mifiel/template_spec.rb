# frozen_string_literal: true

describe Mifiel::Template do
  let!(:template_id) { 'bb7d65b4-47f1-470e-85e4-22ddae86f9ea' }

  shared_examples 'a valid template' do
    it { expect(template).to be_a(described_class) }
    it { expect(template).to respond_to(:id) }
    it { expect(template).to respond_to(:name) }
  end

  describe '#create' do
    let(:template) do
      described_class.create(
        name: 'Some Template',
        content: '<div>Some <field name="name" type="string">NAME</field></div>',
        header: 'Genaros Header',
        footer: 'Genaros Footer',
      )
    end

    it_behaves_like 'a valid template'
  end

  describe '#find' do
    let!(:template) { described_class.find(template_id) }

    it_behaves_like 'a valid template'
    it { expect(template.id).to eq(template_id) }
  end

  describe '#all' do
    let(:templates) { described_class.all }

    it 'responds with many templates' do
      expect(templates.count).to be > 0
    end

    it 'responds with a Template' do
      expect(templates.first).to be_a(described_class)
    end
  end
end
