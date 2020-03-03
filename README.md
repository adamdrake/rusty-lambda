# Rusty Lambda: A skeleton Rust application for AWS Lambda

## Overview

AWS Lambda can be an interesting way to execute functions in a managed service fashion.  It has a variety of runtimes including Go, Python, Node, and so on, but not Rust.  In order to use Rust on Lambda you have to ensure that your Rust application is completely staticly compiled/linked.  In other words, if you're using the Rust standard library, which by default dynamically links to GLIBC, your code will not run properly on Lambda (as of the time of this writing).

This example application uses `musl` instead of `libc` and is an easy way to get around the assumed existence of libc on the host machine.

Further, the documentation I found on AWS and Rust websites was not as clear as it could be.  While some of the code examples are from the AWS GitHub project for Rust, the explanation here is distilled.

## Prerequisites

In order to compile this application you'll need Rust, cargo, and musl-gcc installed.  Assuming you already have Rust and Cargo installed, the install for musl-gcc on Debian/Ubuntu is `apt-get install musl musl-tools`.

Once you have the necessary libraries and toolchain installed, make sure you add the appropriate target for Rust using `rustup`: `rustup target add x86_64-unknown-linux-musl`.  This will install support for the default toolchain.  If you're using nightly, then run `rustup target add x86_64-unknown-linux-musl --toolchain-nightly`.

### Building the example application

To build the application, just run `cargo build` as you normally would.  If you've already created a Lambda function, just change the name in `update.sh` to match the name of the function you created (if necessary).

### Creating a Lambda function

You can create your function on the command line or via the web console.  Important thing to note here is that the name of the handler doesn't matter because there's no runtime and if you create your function using the web interface you should add an environment variable with name `RUST_BACKTRACE` and value `1`.  Using the `aws` command line tool you can create your function as below.  You'll need an existing IAM role to do this.  You can also add a new function via the web interface if that's more convenient.

```bash
aws lambda create-function --function-name rusty-lambda \
  --handler not_used \
  --zip-file file://./bootstrap.zip \
  --runtime provided \
  --role arn:aws:iam::XXXXXXXXXXXXX:role/your_lambda_execution_role \
  --environment Variables={RUST_BACKTRACE=1} \
  --tracing-config Mode=Active
```

### Invoking the example Lambda function

Now that the function is compiled and uploaded, you can do a test run and execute it.

```bash
aws lambda invoke --function-name rusty-lambda \
  --payload '{"firstName": "world"}' \
  output.json && cat output.json && rm output.json
```

Note that in my testing the output file was mandatory, hence the `cat` and `rm` in the above command.

## Updating

If you make changes and would like to update the function, the `update.sh` shell scxript will take care of that.

## Fin

Enjoy using Rust on AWS Lambda!
