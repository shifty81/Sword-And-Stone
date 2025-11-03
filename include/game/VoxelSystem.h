#pragma once

namespace SwordAndStone {
namespace Game {

// Stub voxel system class
class VoxelSystem {
public:
    VoxelSystem();
    ~VoxelSystem();
    
    void Initialize();
    void Update(float deltaTime);
    void Render();
    
private:
    // TODO: Add voxel data structures
};

} // namespace Game
} // namespace SwordAndStone
