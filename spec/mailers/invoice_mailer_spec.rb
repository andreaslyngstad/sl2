describe InvoiceMailer do
	describe 'Sending invoice' do
    let(:firm)        { FactoryGirl.create(:firm, name:"test",invoice_email:"firm@test.com", invoice_email_message: "TEST MESSAGE")}
    let(:user)        { FactoryGirl.create(:user, firm:firm)}
    let(:customer)		{ FactoryGirl.create(:customer, firm:firm, email: "test@test.com")}
    let(:invoice)			{ FactoryGirl.create(:invoice, firm:firm, customer:customer)}
    let(:mail) 				{ InvoiceMailer.invoice(invoice) }
    let(:reminder)		{ InvoiceMailer.reminder(invoice) }
    it 'sends invoice' do
      mail.subject.should eq("Invoice")
      mail.to.should eq(["test@test.com"])
      mail.reply_to.should eq([ "firm@test.com"])
      mail.from.should eq(["no_reply@squadlink.com"])   
      mail.body.encoded.should include(firm.invoice_email_message)
      mail.body.encoded.should include('This invoice is made in <a href="https://squadlink.com">Squadlink</a>')
    end
    it 'sends reminder' do
      reminder.subject.should eq("Reminder")
      reminder.to.should eq(["test@test.com"])
      reminder.reply_to.should eq([ "firm@test.com"])
      reminder.from.should eq(["no_reply@squadlink.com"])   
      reminder.body.encoded.should include('This invoice is made in <a href="https://squadlink.com">Squadlink</a>')
    end
  end
end