(var"##MTKArg#253", var"##MTKArg#254", var"##MTKArg#255", var"##MTKArg#256", var"##MTKArg#257", var"##MTKArg#258")->begin
         @inbounds begin
                let (y₁, y₂, W1₁ˏ₁, W1₂ˏ₁, W1₃ˏ₁, W1₄ˏ₁, W1₅ˏ₁, W1₁ˏ₂, W1₂ˏ₂, W1₃ˏ₂, W1₄ˏ₂, W1₅ˏ₂, b1₁, b1₂, b1₃, b1₄, b1₅, W2₁ˏ₁, W2₂ˏ₁, W2₃ˏ₁, W2₄ˏ₁, W2₅ˏ₁, W2₁ˏ₂, W2₂ˏ₂, W2₃ˏ₂, W2₄ˏ₂, W2₅ˏ₂, W2₁ˏ₃, W2₂ˏ₃, W2₃ˏ₃, W2₄ˏ₃, W2₅ˏ₃, W2₁ˏ₄, W2₂ˏ₄, W2₃ˏ₄, W2₄ˏ₄, W2₅ˏ₄, W2₁ˏ₅, W2₂ˏ₅, W2₃ˏ₅, W2₄ˏ₅, W2₅ˏ₅, b2₁, b2₂, b2₃, b2₄, b2₅, W3₁ˏ₁, W3₁ˏ₂, W3₁ˏ₃, W3₁ˏ₄, W3₁ˏ₅) = (var"##MTKArg#253"[1], var"##MTKArg#253"[2], var"##MTKArg#254"[1], var"##MTKArg#254"[2], var"##MTKArg#254"[3], var"##MTKArg#254"[4], var"##MTKArg#254"[5], var"##MTKArg#254"[6], var"##MTKArg#254"[7], var"##MTKArg#254"[8], var"##MTKArg#254"[9], var"##MTKArg#254"[10], var"##MTKArg#255"[1], var"##MTKArg#255"[2], var"##MTKArg#255"[3], var"##MTKArg#255"[4], var"##MTKArg#255"[5], var"##MTKArg#256"[1], var"##MTKArg#256"[2], var"##MTKArg#256"[3], var"##MTKArg#256"[4], var"##MTKArg#256"[5], var"##MTKArg#256"[6], var"##MTKArg#256"[7], var"##MTKArg#256"[8], var"##MTKArg#256"[9], var"##MTKArg#256"[10], var"##MTKArg#256"[11], var"##MTKArg#256"[12], var"##MTKArg#256"[13], var"##MTKArg#256"[14], var"##MTKArg#256"[15], var"##MTKArg#256"[16], var"##MTKArg#256"[17], var"##MTKArg#256"[18], var"##MTKArg#256"[19], var"##MTKArg#256"[20], var"##MTKArg#256"[21], var"##MTKArg#256"[22], var"##MTKArg#256"[23], var"##MTKArg#256"[24], var"##MTKArg#256"[25], var"##MTKArg#257"[1], var"##MTKArg#257"[2], var"##MTKArg#257"[3], var"##MTKArg#257"[4], var"##MTKArg#257"[5], var"##MTKArg#258"[1], var"##MTKArg#258"[2], var"##MTKArg#258"[3], var"##MTKArg#258"[4], var"##MTKArg#258"[5])
                    (+)((+)((+)((+)((+)(0, (*)(W3₁ˏ₁, (tanh)((+)((+)((+)((+)((+)((+)(0, (*)(W2₁ˏ₁, (tanh)((+)((+)((+)(0, (*)(W1₁ˏ₁, y₁)), (*)(W1₁ˏ₂, y₂)), b1₁)))), (*)(W2₁ˏ₂, (tanh)((+)((+)((+)(0, (*)(W1₂ˏ₁, y₁)), (*)(W1₂ˏ₂, y₂)), b1₂)))), (*)(W2₁ˏ₃, (tanh)((+)((+)((+)(0, (*)(W1₃ˏ₁, y₁)), (*)(W1₃ˏ₂, y₂)), b1₃)))), (*)(W2₁ˏ₄, (tanh)((+)((+)((+)(0, (*)(W1₄ˏ₁, y₁)), (*)(W1₄ˏ₂, y₂)), b1₄)))), (*)(W2₁ˏ₅, (tanh)((+)((+)((+)(0, (*)(W1₅ˏ₁, y₁)), (*)(W1₅ˏ₂, y₂)), b1₅)))), b2₁)))), (*)(W3₁ˏ₂, (tanh)((+)((+)((+)((+)((+)((+)(0, (*)(W2₂ˏ₁, (tanh)((+)((+)((+)(0, (*)(W1₁ˏ₁, y₁)), (*)(W1₁ˏ₂, y₂)), b1₁)))), (*)(W2₂ˏ₂, (tanh)((+)((+)((+)(0, (*)(W1₂ˏ₁, y₁)), (*)(W1₂ˏ₂, y₂)), b1₂)))), (*)(W2₂ˏ₃, (tanh)((+)((+)((+)(0, (*)(W1₃ˏ₁, y₁)), (*)(W1₃ˏ₂, y₂)), b1₃)))), (*)(W2₂ˏ₄, (tanh)((+)((+)((+)(0, (*)(W1₄ˏ₁, y₁)), (*)(W1₄ˏ₂, y₂)), b1₄)))), (*)(W2₂ˏ₅, (tanh)((+)((+)((+)(0, (*)(W1₅ˏ₁, y₁)), (*)(W1₅ˏ₂, y₂)), b1₅)))), b2₂)))), (*)(W3₁ˏ₃, (tanh)((+)((+)((+)((+)((+)((+)(0, (*)(W2₃ˏ₁, (tanh)((+)((+)((+)(0, (*)(W1₁ˏ₁, y₁)), (*)(W1₁ˏ₂, y₂)), b1₁)))), (*)(W2₃ˏ₂, (tanh)((+)((+)((+)(0, (*)(W1₂ˏ₁, y₁)), (*)(W1₂ˏ₂, y₂)), b1₂)))), (*)(W2₃ˏ₃, (tanh)((+)((+)((+)(0, (*)(W1₃ˏ₁, y₁)), (*)(W1₃ˏ₂, y₂)), b1₃)))), (*)(W2₃ˏ₄, (tanh)((+)((+)((+)(0, (*)(W1₄ˏ₁, y₁)), (*)(W1₄ˏ₂, y₂)), b1₄)))), (*)(W2₃ˏ₅, (tanh)((+)((+)((+)(0, (*)(W1₅ˏ₁, y₁)), (*)(W1₅ˏ₂, y₂)), b1₅)))), b2₃)))), (*)(W3₁ˏ₄, (tanh)((+)((+)((+)((+)((+)((+)(0, (*)(W2₄ˏ₁, (tanh)((+)((+)((+)(0, (*)(W1₁ˏ₁, y₁)), (*)(W1₁ˏ₂, y₂)), b1₁)))), (*)(W2₄ˏ₂, (tanh)((+)((+)((+)(0, (*)(W1₂ˏ₁, y₁)), (*)(W1₂ˏ₂, y₂)), b1₂)))), (*)(W2₄ˏ₃, (tanh)((+)((+)((+)(0, (*)(W1₃ˏ₁, y₁)), (*)(W1₃ˏ₂, y₂)), b1₃)))), (*)(W2₄ˏ₄, (tanh)((+)((+)((+)(0, (*)(W1₄ˏ₁, y₁)), (*)(W1₄ˏ₂, y₂)), b1₄)))), (*)(W2₄ˏ₅, (tanh)((+)((+)((+)(0, (*)(W1₅ˏ₁, y₁)), (*)(W1₅ˏ₂, y₂)), b1₅)))), b2₄)))), (*)(W3₁ˏ₅, (tanh)((+)((+)((+)((+)((+)((+)(0, (*)(W2₅ˏ₁, (tanh)((+)((+)((+)(0, (*)(W1₁ˏ₁, y₁)), (*)(W1₁ˏ₂, y₂)), b1₁)))), (*)(W2₅ˏ₂, (tanh)((+)((+)((+)(0, (*)(W1₂ˏ₁, y₁)), (*)(W1₂ˏ₂, y₂)), b1₂)))), (*)(W2₅ˏ₃, (tanh)((+)((+)((+)(0, (*)(W1₃ˏ₁, y₁)), (*)(W1₃ˏ₂, y₂)), b1₃)))), (*)(W2₅ˏ₄, (tanh)((+)((+)((+)(0, (*)(W1₄ˏ₁, y₁)), (*)(W1₄ˏ₂, y₂)), b1₄)))), (*)(W2₅ˏ₅, (tanh)((+)((+)((+)(0, (*)(W1₅ˏ₁, y₁)), (*)(W1₅ˏ₂, y₂)), b1₅)))), b2₅))))
                end
            end
    end