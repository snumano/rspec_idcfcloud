# coding: utf-8
require 'spec_helper'

newBucketName = Faker::Lorem.characters(10)
newApiUserName = 'idcf_' + Faker::Internet.email

# export ABC='abc'
# RSPEC_ID
# RSPEC_PW
# RSPEC_EXIST_ID 


# Selenium起動時注意点
# * describeの後に", js: true"を追加。spec_helperにて、config.default_driverをコメントアウト
# * beforeのlogoutが効いていない。よって、loginを期待している部分で適切な画面でないので、errとなる。

describe 'Object Storage' do
  before do
    visit '/objectstorage'
    fill_in('username', :with => ENV['RSPEC_ID'])
    fill_in('password', :with => ENV['RSPEC_PW'])
    click_on('ログイン')
#    save_and_open_page
  end
  
  shared_examples_for 'check the side menu and username' do
    it 'has the side menu and username' do
      expect(page).to have_content ENV['RSPEC_ID'] # 画面右上のログインIDにマッチング
      expect(page).to have_content 'APIユーザー'
      expect(page).to have_content 'オブジェクト'
      expect(page).to have_content '利用状況'
    end
  end

  subject{page}
  describe 'APIユーザー as Defaut page' do
    it_should_behave_like 'check the side menu and username'
    it "checks the words on the top" do
      within(:css, '#page-heading > h1') do
        expect(page).to have_content 'APIユーザー'
      end
    end
  end

#1. 動作　ひと通りおさえる
#2. api userをfakerに置き換える
#3. jenkins, chat bot 連携
#4. github, bitbucketに置く。今後、開発中のtestも考慮し、private repositoryで。

  describe "APIユーザー" do
    before do
      within(:css, '#page-leftbar') do
        click_on 'APIユーザー'
      end
    end

    it_should_behave_like 'check the side menu and username'
    it "checks the words on the top" do
      within(:css, '#page-heading > h1') do
        expect(page).to have_content 'APIユーザー'
      end
    end

    it 'searches an API user' do
      find(:xpath, "//input[@type='text']").native.send_keys(ENV['RSPEC_EXIST_ID'])
      expect(page).to have_content ENV['RSPEC_EXIST_ID']
    end
    it "creates a new api user" do
      pending('APIユーザー上限数変更後、本テスト実施')
      fail
      find(:css, '#page-heading > div > div > a').click # "APIユーザー追加"ボタンをclick
      expect(page).to have_content 'APIユーザーの追加'
      expect(page).to have_content 'リージョン'
      expect(page).to have_content 'APIユーザー名'
      fill_in('apiUserName', :with => newApiUserName)
      click_on('OK')
      expect(page).to have_content 'APIユーザーを作成しました。'
    end

    describe 'Existing APIユーザー' do
      before do
        click_on(ENV['RSPEC_EXIST_ID'])
      end
      describe 'API Key' do
        before do
          click_on('API Key')
        end
        it "shows the words" do
          expect(page).to have_content 'エンドポイント'
          expect(page).to have_content 'プライベートコネクト'
          expect(page).to have_content 'API Key'
          expect(page).to have_content 'Secret Key'
        end
        it 'click プライベートコネクト' do
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(1) > form > div.form-group.form-group-endpoint > div > ul > li:nth-child(2) > a').click # プライベートコネクトをクリック
          expect(page).to have_content 'エンドポイント'
          expect(page).to have_content 'プライベートコネクト'
          expect(page).to have_content 'API Key'
          expect(page).to have_content 'Secret Key'
        end
      end
      
      describe '基本設定' do
        before do
          click_on('基本設定')
        end
        it 'shows the words' do
          expect(page).to have_content 'ID'
          expect(page).to have_content 'APIユーザー名'
          expect(page).to have_content '作成日'
        end
      end

      describe 'リセット' do
        before do
          click_on('リセット')
        end
        it 'shows the words' do
          expect(page).to have_content 'Secret Keyをリセットします。'
        end
        it "shows modal window and click OK" do 
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(3) > div > div.text-right > a').click
          expect(page).to have_content 'シークレットキーをリセットします。よろしいですか？'
          click_on('OK')
          expect(page).to have_content 'シークレットキーをリセットしました。'
        end
        
        it "shows modal window and click Cancel" do
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(3) > div > div.text-right > a').click
          expect(page).to have_content 'シークレットキーをリセットします。よろしいですか？'
          click_on('Cancel')
          expect(page).not_to have_content 'シークレットキーをリセットしました。'
          expect(page).to have_content 'Secret Keyをリセットします。'
        end
      end

      describe '無効化' do
        before do
          click_on('無効化')
        end
        it "shows the words" do
          expect(page).to have_content 'API Keyを無効化します。'
        end
        it '無効化後、有効化' do
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(4) > div > div > a').click
          expect(page).to have_content 'APIキーを無効化します。よろしいですか？'
          click_on('OK')
          expect(page).to have_content 'APIキーを無効化しました。'

          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(5) > div > div > a').click
          expect(page).to have_content 'APIキーを有効化します。よろしいですか？'
          click_on('OK')
          expect(page).to have_content 'APIキーを有効化しました。'
        end
        it '無効化キャンセル' do
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(4) > div > div > a').click
          expect(page).to have_content 'APIキーを無効化します。よろしいですか？'
          click_on('Cancel')
          expect(page).not_to have_content 'APIキーを無効化しました。'
          expect(page).to have_content 'API Keyを無効化します。'
        end
        it '無効化後、有効化キャンセル' do
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(4) > div > div > a').click
          expect(page).to have_content 'APIキーを無効化します。よろしいですか？'
          click_on('OK')
          expect(page).to have_content 'APIキーを無効化しました。'

          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(5) > div > div > a').click
          expect(page).to have_content 'APIキーを有効化します。よろしいですか？'
          click_on('Cancel')
          expect(page).to have_content 'APIキーを無効化しました。'
          expect(page).not_to have_content 'APIキーを有効化しました。'
          find(:css, 'body > div.modal.fade.ng-isolate-scope.in > div > div > div.modal-body.ng-scope > div:nth-child(5) > div > div > a').click
          click_on('OK')
          expect(page).to have_content 'APIキーを有効化しました。'
        end
      end
    end
  end

  describe "オブジェクト" do
    before do
      within(:css, '#page-leftbar') do
        click_on 'オブジェクト'
      end
    end
    it_should_behave_like 'check the side menu and username'
    it{should have_content 'Bucket Action'}

    context 'with ' + ENV['RSPEC_EXIST_ID'] do
      before do
        find(:css, 'a.dropdown-toggle > i.fa.fa-caret-down').click
        find('li', :text => ENV['RSPEC_EXIST_ID']).click
        sleep(3)
      end
      it "checks the words" do
        expect(page).to have_content ENV['RSPEC_EXIST_ID']
        expect(page).to have_content 'バケット'
        expect(page).to have_content 'Bucket Action'
      end
      describe "creates a bucket" do
        before do
=begin
          p page.find(:css, '#bucket-0 > div:nth-child(2) > a > span')
          p page.methods.sort
          if expect(page).to have_css('#bucket-0 > div:nth-child(2) > a > span')
            p 'YES'
          else
            p 'NO'
          end
          
          # 事前に当該API Userのバケットを全て削除する
          find(:css, '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(1) > thead > tr > th.name > div > a > i').click
          find(:css,'#wrap > div.container.container-objects > div:nth-child(1) > div > div > div.action-button-area > div > div > div:nth-child(1) > div:nth-child(1) > button').click
          find(:css, '#wrap > div.container.container-objects > div:nth-child(1) > div > div > div.action-button-area > div > div > div:nth-child(1) > div.btn-group.open > ul > li:nth-child(4) > a').click
          find(:css, "div.modal-footer.ng-scope > button.btn.btn-primary").click # OKをクリック
          find(:css, '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(1) > thead > tr > th.name > div > a > i').click
=end
          # Bucket Actionをクリックして、バケット作成をクリック
          # Bucket作成が失敗する場合には、別アカウントで試すこと。
          find(:css,'#wrap > div.container.container-objects > div:nth-child(1) > div > div > div.action-button-area > div > div > div:nth-child(1) > div:nth-child(1) > button').click
          find(:css, '#wrap > div.container.container-objects > div:nth-child(1) > div > div > div.action-button-area > div > div > div:nth-child(1) > div.btn-group.open > ul > li:nth-child(1) > a').click
          fill_in('bucketName', :with => newBucketName)
          click_on('OK')
          find(:xpath, "//div[@id='wrap']/div/div[2]/div/div/table/thead/tr/th/a/i").click
#          save_and_open_page
        end
        it{should have_content newBucketName}
        it 'shows detailed information' do
#          p page.current_url

          charset = nil
          html = open(page.current_url) do |f|
            charset = f.charset #文字種別を取得します。
            f.read #htmlを読み込み変数htmlに渡します。
          end
          doc = Nokogiri::HTML.parse(html, nil, charset)
=begin
          p '==========='
          p doc.xpath('//*[@id="wrap"]/div[1]/div[2]/div/div/table[2]')
          p '==========='
          p doc.search('//*[@id="wrap"]/div[1]/div[2]/div/div/table[2]/tbody/tr')
          p '==========='
          doc.xpath('//*[@id="wrap"]/div[1]/div[2]/div/div/table[2]/tbody/tr').each do |node|
            p node
          end
          p '==========='
=end
          pending('調査中')

=begin
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).text
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).right_click
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).right_click.values
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).right_click.to_json
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).right_click.method
          p find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2) > tbody > tr > td', :text => newBucketName).right_click.methods.sort

=end

#bucket-0 > div:nth-child(2)

          find(:css , '#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2)', :text => newBucketName).right_click
          find('li', :text => '詳細').click
#menu-3 > ul > li:nth-child(1) > a
#menu-3 > ul > li:nth-child(1) > a
#menu-3 > ul > li:nth-child(1) > a

          save_and_open_page
#wrap > div.container.container-objects > div.row.row-objects.ng-scope > div > div > table:nth-child(2)
#bucket-0 > div:nth-child(2) > a > span
#bucket-1 > div:nth-child(2) > a > span
        end
        describe 'upload files' do
          it 'uploads files'
          it 'shows detailed information'
          it 'deletes files'
        end
        describe 'create a Folder' do
          it 'shows the folder'
          it 'shows detailed information'
          it 'deletes the folder'
          describe 'upload files' do
            it 'uploads files'
            it 'shows detailed information'
            it 'deletes files'
          end
        end
      end
      describe 'delete Bucket' do
        it 'deletes the Bucket'
      end
    end
  end

  describe "利用状況" do
    before do
      within(:css, '#page-leftbar') do
        click_on '利用状況'
      end
    end

    it_should_behave_like 'check the side menu and username'
    it "checks the words" do
      within(:css , '#page-heading > h1') do
        expect(page).to have_content '利用状況'
      end
    end
  end
end
