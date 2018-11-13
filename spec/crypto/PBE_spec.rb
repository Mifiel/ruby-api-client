describe Crypto::PBE do
  pbe_fixture = JSON.parse(File.read('spec/fixtures/pbe.json'), symbolize_names: true)
  let(:alpha_num) { ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a }
  let(:specials) { ['-', '_', '+', '=', '#', '&', '*', '.'] }
  let(:valid_chars) { alpha_num + specials }

  describe "#PBE good" do
    pbe_fixture[:valid].each do | v |
      describe "#{v.slice(:key, :salt, :keylen, :iterations)}" do
        let(:pbe) { Crypto::PBE.new(v[:iterations]) }
        let(:key) { pbe.derived_key(v[:key], v[:salt], v[:keylen]) }
        it 'should return a strong key' do
          expect(key.to_hex).to eq(v[:result])
        end
      end
    end

    describe "Generate random keys" do
      let(:keys) { Set.new }
      5.times do
        key = Crypto::PBE.generate.to_hex
        it "should be unique #{key}" do
          expect(keys.include?(key)).to be false
          keys.add(key)
        end
      end
    end

    describe "Random password + size" do
      let(:passwords) { Set.new }
      key_lens = [32, 64, 40]
      5.times do
        size = key_lens.sample
        pass = Crypto::PBE.new.random_password(size)
        it "should be unique #{pass}" do
          expect(passwords.include?(pass)).to be false
          passwords.add(pass)
        end
        it "should be size #{size}" do
          expect(pass.length).to be size
        end
        it "should contain specified chars" do
          pass_chars = pass.chars
          expect(pass_chars).to eq(pass_chars & valid_chars)
        end
      end
    end
  end

  describe '#PBE bad' do
    pbe_fixture[:invalid].each do | v |
      describe "#{v[:description]}" do
        let(:pbe){ Crypto::PBE.new(v[:iterations]) }
        let(:error){ "integer #{v[:keylen]} too big to convert to `int'" }
        it 'should raise key length error' do
          expect{ pbe.derived_key(v[:key], v[:salt], v[:keylen]) }.to raise_error(RangeError, error)
        end
      end
    end
  end
end
