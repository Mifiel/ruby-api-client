describe Mifiel::Crypto::PBE do
  pbe_fixture = JSON.parse(File.read('spec/fixtures/pbe.json'), symbolize_names: true)
  let(:alpha_num) { ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a }
  let(:specials) { ['-', '_', '+', '=', '#', '&', '*', '.'] }
  let(:valid_chars) { alpha_num + specials }

  describe '#PBE good' do
    pbe_fixture[:valid].each do |values|
      describe values.slice(:password, :salt, :key_size, :iterations).to_s do
        let(:result) { values[:result] }
        let(:key) { Mifiel::Crypto::PBE.derive_key(values.slice!(:result)) }
        it 'should return a strong key' do
          expect(key.bth).to eq(result)
        end
      end
    end

    describe 'Random password & random salt' do
      let(:passwords) { Set.new }
      let(:salts) { Set.new }
      key_lens = [32, 64, 40]
      5.times do
        size = key_lens.sample
        pass = Mifiel::Crypto::PBE.random_password(size)
        salt = Mifiel::Crypto::PBE.random_salt.bth
        it "should be unique salt: #{salt}" do
          expect(salts.include?(salt)).to be false
          salts.add(pass)
        end
        it "should be unique password: #{pass}" do
          expect(passwords.include?(pass)).to be false
          passwords.add(pass)
        end
        it "should be size #{size}" do
          expect(pass.length).to be size
        end
        it 'should contain specified chars' do
          pass_chars = pass.chars
          expect(pass_chars).to eq(pass_chars & valid_chars)
        end
      end
    end
  end

  describe '#PBE bad' do
    pbe_fixture[:invalid].each do |values|
      describe values[:description].to_s do
        let(:error) { "integer #{values[:key_size]} too big to convert to `int'" }
        it 'should raise key length error' do
          expect { Mifiel::Crypto::PBE.derive_key(values.slice!(:description)) }.to raise_error(Mifiel::PBError, error)
        end
      end
    end
  end
end
