defmodule Auth.UserTest do
	use Storage.RepoCase

	alias Auth.User, as: Subject

	describe "create/1" do
		test "successfuly create a user" do
			params = %{
				email: "mail@domain.test",
				password: "qazWSX123"
			}

			assert {:ok, _user} = Subject.create(params)
		end

		test "returns error when required fields are not passed" do
      params = %{}

      assert {:error, result} = Subject.create(params)

      assert "can't be blank" in errors_on(result).email
      assert "can't be blank" in errors_on(result).password
		end

		test "returns error when email has an incorrect format" do
			params = %{
				email: "invalid_email",
				password: "qazWSX123"
			}

      assert {:error, result} = Subject.create(params)

      assert "invalid format" in errors_on(result).email
		end

		test "returns error when password is too weak" do
			params = %{
				email: "mail@domain.test",
				password: "1234"
			}

      assert {:error, result} = Subject.create(params)

      assert "too weak" in errors_on(result).password
		end
	end
end
