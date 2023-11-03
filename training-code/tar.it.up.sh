


rm -f ./pipeline-artifacts/training-artifacts/train-step.tar.gz

tar  -czvf \
    pipeline-artifacts/training-artifacts/train-step.tar.gz \
    card_transdata.csv \
    requirements.txt \
    train.py

rm -f ./pipeline-artifacts/training-artifacts/upload-step.tar.gz

tar  -czvf \
    pipeline-artifacts/training-artifacts/upload-step.tar.gz \
    upload.py

