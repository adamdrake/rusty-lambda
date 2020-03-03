cargo build --release --target x86_64-unknown-linux-musl && \
cp ./target/x86_64-unknown-linux-musl/release/bootstrap ./bootstrap && zip -j bootstrap.zip bootstrap && rm bootstrap && \
aws lambda update-function-code --function-name rusty-lambda --zip-file fileb://bootstrap.zip && rm bootstrap.zip
