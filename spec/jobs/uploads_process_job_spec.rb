require 'rails_helper'

RSpec.describe UploadsProcessJob do
  context 'success' do
    describe '#perform' do
      it 'Job is enqueued' do
        ActiveJob::Base.queue_adapter = :test
        expect {
          UploadsProcessJob.perform_later
        }.to have_enqueued_job(UploadsProcessJob)
      end
    end
  end
end
