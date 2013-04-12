# use require to load any .js file available to the asset pipeline
#= require donation

describe "Donation Model", ->
  it 'exists', ->
    expect(DP.models.Donation).toBeDefined()
