require "minitest_helper"

class GlossariesControllerTest < MiniTest::Rails::ActionController::TestCase

  before do
    @glossary = Glossary.new
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:glossaries)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Glossary.count') do
      post :create, glossary: @glossary.attributes
    end

    assert_redirected_to glossary_path(assigns(:glossary))
  end

  def test_show
    get :show, id: @glossary.to_param
    assert_response :success
  end

  def test_edit
    get :edit, id: @glossary.to_param
    assert_response :success
  end

  def test_update
    put :update, id: @glossary.to_param, glossary: @glossary.attributes
    assert_redirected_to glossary_path(assigns(:glossary))
  end

  def test_destroy
    assert_difference('Glossary.count', -1) do
      delete :destroy, id: @glossary.to_param
    end

    assert_redirected_to glossaries_path
  end
end
