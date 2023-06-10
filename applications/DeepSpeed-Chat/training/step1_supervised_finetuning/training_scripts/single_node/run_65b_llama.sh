#!/bin/bash
# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team
OUTPUT=$1
ZERO_STAGE=$2
if [ "$OUTPUT" == "" ]; then
    OUTPUT=./output_llama_65b
fi
if [ "$ZERO_STAGE" == "" ]; then
    ZERO_STAGE=3
fi
mkdir -p $OUTPUT
###--model_name_or_path huggyllama/llama-7b \
deepspeed main.py \
   --data_path Dahoas/rm-static Dahoas/full-hh-rlhf \
   --data_split 2,4,4 \
   --model_name_or_path huggyllama/llama-65b \
   --per_device_train_batch_size 4 \
   --per_device_eval_batch_size 4 \
   --max_seq_len 512 \
   --learning_rate 1e-4 \
   --weight_decay 0. \
   --num_train_epochs 5  \
   --gradient_accumulation_steps 1 \
   --lr_scheduler_type cosine \
   --num_warmup_steps 0 \
   --seed 1234 \
   --gradient_checkpointing \
   --zero_stage $ZERO_STAGE \
   --lora_dim 256 \
   --lora_module_name model.layers. \
   --deepspeed \
   --output_dir $OUTPUT \
   &> $OUTPUT/training.log
